// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

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

    mapping(uint256 => Product) public products;
    mapping(address => User) public users;

    uint256 private totalUsers;
    uint256 private totalProducts;

    address[] public userAddressList;
    uint8[] public productAddressList;

    modifier onlyRole(Role _role) {
        
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

    modifier transferAllowed(uint8 _productId, ProductLocation _location) {
        
        Product storage product = products[_productId];

        ProductLocation current = product.currentlocation;

        address tranferer = msg.sender;

        require(users[tranferer].role != Role.Administrator, "Admin cant transfer product");

        if (current == ProductLocation.Manufacturer) {
            require(users[tranferer].role == Role.Supplier, "Transfer not allowed");
            require(_location == ProductLocation.Supplier, "Transfer not allowed");

        } else if (current == ProductLocation.Supplier) {
            require(users[tranferer].role == Role.LogisticEmployee, "Transfer not allowed");
            require(_location == ProductLocation.LogisticWarehouse || _location == ProductLocation.Courier, "Transfer not allowed");

        } else if (current == ProductLocation.LogisticWarehouse || current == ProductLocation.Courier) {
            require(users[tranferer].role == Role.Controller, "Transfer not allowed");
            require(_location == ProductLocation.Pharmacy, "Transfer not allowed");

        } else {
            require(false, "Transfer not allowed");
        }
        _;
    }


    // Constructor to set the contract creator as the administrator
    constructor() {
        users[msg.sender].walletAddress = msg.sender;
        users[msg.sender].name = "mpked2314";
        users[msg.sender].email = "mpked2314@unipi.gr";
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

        }


    function addProduct(uint8 _productId, string memory _name, uint8 _quantity) public  onlyRole(Role.Administrator)  productAlreadyExist( _productId){

            Product storage product = products[_productId];

            uint256 transferId = rand();

            product.productId = _productId;
            product.name = _name;
            product.quantity = _quantity;
            product.currentOwner = msg.sender;
            product.currentlocation = ProductLocation.Manufacturer;// Starting Point

            product.shippingHistory.push(ShippingData(transferId, msg.sender, block.timestamp, product.currentlocation, _quantity));

            totalProducts++;
            productAddressList.push(uint8(_productId));

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

            Product storage product = products[_productId];
            User storage user = users[msg.sender];

            ProductLocation CheckLocation = product.currentlocation;
            Role userRole = user.role;
            
            if (userRole == Role.Administrator) {
                return (product.name,product.quantity, product.currentOwner, product.currentlocation, product.shippingHistory);

            } else if(userRole == Role.Supplier && CheckLocation == ProductLocation.Manufacturer) {
                return (product.name, product.quantity, product.currentOwner, product.currentlocation, product.shippingHistory);

            } else if(userRole == Role.LogisticEmployee && CheckLocation == ProductLocation.Supplier) {
                return (product.name, product.quantity, product.currentOwner, product.currentlocation, product.shippingHistory);

             } else if(userRole == Role.LogisticEmployee && CheckLocation == ProductLocation.LogisticWarehouse) {
                return (product.name, product.quantity, product.currentOwner, product.currentlocation, product.shippingHistory);

            } else if(userRole == Role.Controller) {
                return (product.name, product.quantity, product.currentOwner, product.currentlocation, product.shippingHistory);

            } else {
                return ("Access Denied to ger products", 0, address(0), ProductLocation.Default, new ShippingData[](0));
            }       
        }

   

    function addTranfer(uint8 _productId, uint256 _transferId, ProductLocation _location) public userExist() transferAllowed(_productId, _location) productExistsForTransfer (_productId, _transferId){

            Product storage product = products[_productId];

            uint256 transferIdss = product.shippingHistory[0].transferId;

            product.shippingHistory.push(ShippingData(transferIdss, msg.sender, block.timestamp, _location, product.quantity));
            product.currentOwner = msg.sender;
            product.currentlocation = _location;

        }


//helper functions
    function getMyPrsonalInfo() public  userExist() view returns (address _walletAddress, string memory _name, string memory _email, string memory _role) {
        
            User storage user = users[msg.sender];
                
        return (user.walletAddress, user.name, user.email, getUserRole(msg.sender));
    }

    function getUserlInfo(address _walletAddress) public  onlyRole(Role.Administrator) view returns (string memory _name, string memory _email, string memory _role) {
        
            User storage user = users[_walletAddress];
                
        return (user.name, user.email, getUserRole(_walletAddress));
    }

    function getUserRole(address _user) public view returns (string memory) {

        User storage user = users[_user];

        if (user.role == Role.Administrator) {
            return "Administrator";
        } else if (user.role == Role.Supplier) {
            return "Supplier";
        } else if (user.role == Role.LogisticEmployee) {
            return "Logistic Employee";
        } else if (user.role == Role.Controller) {
            return "Controller";
        } else {
            return "Invalid role";
        }
    }

     function getAddressList() public view  onlyRole(Role.Administrator) returns  (address[] memory) {
        return (userAddressList);
    }

    function getProductList() public view  userExist() returns  (uint8[] memory) {
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