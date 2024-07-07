// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//TODO
// 1. check (public, internal, external, private)
// 2. check fees for adding and updating products
// 3. check the roles and the access to the functions

import "hardhat/console.sol";

contract PharmacyChain {

    struct Product {
        uint8 productId;
        string name;
        uint8 quantity;
        address currentOwner;    
        ProductLocation currentlocation;
        ShippingData[] shippingHistory;
    }
    struct ShippingData {
        uint256 transferId;
        address makeTransfer;
        uint256 timestamp;
        ProductLocation location;
        uint8 quantity;
    }
    struct User {
        address walletAddress;
        string name;
        string email;   
        Role role;
    }
    // Enum to store the roles and the product location
    enum ProductLocation {Default, Manufacturer, Supplier, LogisticWarehouse,Courier, Pharmacy }
    enum Role {Default, Administrator, Supplier, LogisticEmployee, Controller }

    mapping(address => Role) public roles;
    mapping(uint256 => Product) public products;
    mapping(address => User) public users;

    uint256 private totalUsers;
    uint256 private totalProducts;

    address[] public userAddressList;
    uint8[] public productAddressList;

    uint256 public addProductFee = 0.01 ether;
    uint256 public updateProductFee = 0.1 ether;

    event UserAdded(address indexed user, Role role, string name, string email);
    event UserRemoved(address indexed participant);
   
    event ProductAdded(uint8 indexed productId, string name, address indexed owner, uint256 quantity);
    event ProductUpdated(uint8 indexed productId, address indexed from, address indexed to, ProductLocation location, uint256 quantity);

    event TransferAdded(uint256 indexed transferId, uint8 indexed productId, address indexed makeTransfer, ProductLocation location);
    event TransferUpdated(uint256 indexed transferId, address indexed from, address indexed to, ProductLocation location);

    modifier onlyRole(Role _role) {
        console.log("From onlyrole",getUserRole(msg.sender));
        
        User storage user = users[msg.sender];

        require(user.role == _role, "Access denied");
        _;
    }
    
    modifier userExist() {

        require(users[msg.sender].walletAddress == msg.sender, "User does not exist");
        _;
    }

    modifier userAlreadyExist(address _user) {
        User storage user = users[_user];
        require(user.walletAddress != _user, "User already exists");
        _;
    }

    modifier walletExist(address _walletAddress) {

        require(users[_walletAddress].walletAddress == _walletAddress, "User does not exist");
        _;
    }

    modifier productAlreadyExist(uint8 _productId) {
        
        Product storage product = products[_productId];

        require(product.productId != _productId, "Product already exists");
        _;
    }

    modifier porductIdExist(uint8 _productId) {
        Product storage product = products[_productId];
        require(product.productId == _productId, "Product does not exist");
        _;
    }

    modifier productExistsForTransfer(uint8 _productId , uint256 _transferId) {
        Product storage product = products[_productId];
        require(product.productId == _productId, "Product does not exist");
        ShippingData storage shippingData = product.shippingHistory[0];
        require(shippingData.transferId == _transferId, "Transfer does not exist");
            _;
    }



    modifier costs(uint256 amount) {
        require(msg.value >= amount, "Insufficient funds sent");
        _;
    }

    // Constructor to set the contract creator as the administrator
    constructor() {
        users[msg.sender].walletAddress = msg.sender;
        users[msg.sender].name = "Administrator";
        users[msg.sender].email = "admin@mypharmachain.com";
        users[msg.sender].role = Role.Administrator;

        totalUsers++;
        userAddressList.push(address(msg.sender));
    }

    function addUser(address _user, string memory _name, string memory _email, Role _role) public onlyRole(Role.Administrator) userAlreadyExist(_user){
            
            User storage user = users[_user];

            user.walletAddress = _user;
            user.name = _name;
            user.email = _email;
            user.role = _role;

            totalUsers++;
            userAddressList.push(address(user.walletAddress));

            console.log("From addUser",totalUsers);
            emit UserAdded(_user, _role, _name, _email);
        }

    function deleteUser(address _user) public onlyRole(Role.Administrator) walletExist(_user){
            delete users[_user];
            totalUsers--;

            for (uint i = 0; i < userAddressList.length; i++) {
                if (userAddressList[i] == _user) {
                    userAddressList[i] = userAddressList[userAddressList.length - 1];
                    userAddressList.pop();
                    break;
                }
            }

            emit UserRemoved(_user);
        }


    function addProduct(uint8 _productId, string memory _name, uint8 _quantity) public  onlyRole(Role.Administrator)  productAlreadyExist( _productId){
            console.log("From addProduct",msg.sender);

            Product storage product = products[_productId];

            uint256 transferId = rand();

            product.productId = _productId;
            product.name = _name;
            product.quantity = _quantity;
            product.currentOwner = msg.sender;
            product.currentlocation = ProductLocation.Manufacturer;// Starting Point

            product.shippingHistory.push(ShippingData(transferId, msg.sender, block.timestamp, product.currentlocation, _quantity));
            console.log(transferId);

            totalProducts++;
            productAddressList.push(uint8(_productId));

            emit ProductAdded(_productId, _name, msg.sender,  _quantity);
        }
    
    function deleteProduct(uint8 _productId)  onlyRole(Role.Administrator)  porductIdExist(_productId) public {
            delete products[_productId];

            totalProducts--;

            for (uint i = 0; i < productAddressList.length; i++) {
                if (productAddressList[i] == _productId) {
                    productAddressList[i] = productAddressList[productAddressList.length - 1];
                    productAddressList.pop();
                    break;
                }
            }
        }

    function getProduct(uint8 _productId) public userExist() view returns (string memory Name, uint8 Quantity, address CurrentOwner, ProductLocation CurrentLocation, ShippingData[] memory ShippingHistory) {

            console.log("From getProduct user address",msg.sender);

            Product storage product = products[_productId];
            User storage user = users[msg.sender];

            ProductLocation CheckLocation = product.currentlocation;
            Role userRole = user.role;
            
            if (userRole == Role.Administrator) {
                console.log("Admin -- Manufacturer");
                return (product.name,product.quantity, product.currentOwner, product.currentlocation, product.shippingHistory);
            } else if(userRole == Role.Supplier && CheckLocation == ProductLocation.Supplier) {
                console.log("Supplier -- Supplier");
                return (product.name, product.quantity, product.currentOwner, product.currentlocation, product.shippingHistory);
            } else if(userRole == Role.LogisticEmployee && CheckLocation == ProductLocation.LogisticWarehouse) {
                console.log("LogisticEmployee -- LogisticWarehouse");
                return (product.name, product.quantity, product.currentOwner, product.currentlocation, product.shippingHistory);
            } else if(userRole == Role.Controller) {
                console.log("Controller");
                return (product.name, product.quantity, product.currentOwner, product.currentlocation, product.shippingHistory);
            } else {
                return ("Access Denied", 0, address(0), ProductLocation.Default, new ShippingData[](0));
            }       
        }

   

    function addTranfer(uint8 _productId, uint256 _transferId, ProductLocation _location) public productExistsForTransfer (_productId, _transferId){

            Product storage product = products[_productId];

            uint256 transferIdss = product.shippingHistory[0].transferId;
            console.log("From addTranfer",transferIdss);

            product.shippingHistory.push(ShippingData(transferIdss, msg.sender, block.timestamp, _location, product.quantity));
            // product.currentOwner = msg.sender;
            product.currentlocation = _location;

            emit TransferAdded(_transferId, _productId, msg.sender, _location);
        }


//helper functions

    function getMyPrsonalInfo() public  userExist() view returns (address _walletAddress, string memory _name, string memory _email, string memory _role) {
        
            User storage user = users[msg.sender];
                
            console.log("From getMyPrsonalInfo",user.walletAddress);

        return (user.walletAddress, user.name, user.email, getUserRole(msg.sender));
    }

    function getUserlInfo(address _walletAddress) public  onlyRole(Role.Administrator) view returns (string memory _name, string memory _email, string memory _role) {
        
            User storage user = users[_walletAddress];
                
            console.log("From getUserslInfo",user.walletAddress);

        return (user.name, user.email, getUserRole(_walletAddress));
    }

    function getUserRole(address _user) public view returns (string memory) {

        User storage user = users[_user];

        if (user.role == Role.Administrator) {
            console.log("Admin", _user);
            console.log("Admin", user.name);
            return "Administrator";
        } else if (user.role == Role.Supplier) {
            console.log("Supplier", _user);
            return "Supplier";
        } else if (user.role == Role.LogisticEmployee) {
            console.log("LogisticEmployee", _user);
            return "Logistic Employee";
        } else if (user.role == Role.Controller) {
            console.log("Controller", _user);
            return "Controller";
        } else {
            console.log("Invalid role", _user);
            return "Invalid role";
        }
    }

     function getAddressList() public view  onlyRole(Role.Administrator) returns  (address[] memory) {
        return (userAddressList);
    }

    function getProductList() public view  onlyRole(Role.Administrator) returns  (uint8[] memory) {
        return (productAddressList);
    }

    // This function is used to generate a random number for the transferId
    function rand() public view returns(uint256)
        {
            uint256 seed = uint256(keccak256(abi.encodePacked(
                block.timestamp + block.prevrandao +
                ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (block.timestamp)) +
                block.gaslimit + 
                ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (block.timestamp)) +
                block.number
            )));

            return (seed - ((seed / 1000) * 1000));
        }
        //These are functions to stop get errors from metamask to hardhat test network
        receive() external payable {}
        fallback() external payable {}
    
}