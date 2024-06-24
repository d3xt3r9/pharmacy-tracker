// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";


contract PharmacyChain {
    // Structs to store the product data
    struct Product {    
        string name;
        address currentOwner;
        uint256 quantity;
        ProductLocation location;
        ShippingData[] shippingHistory;
    }
    // Struct to store the shipping data
    struct ShippingData {
        address from;
        address to;
        uint256 timestamp;
        string location;
        uint256 quantity;
    }
    // Struct to store the user data
    struct User {
        string name;
        string email;
        address walletAddress;
        Role role;
    }
    // Enum to store the roles and the product location
    enum ProductLocation { Manufacturer, Supplier, LogisticWarehouse, Pharmacy }
    enum Role { Administrator, Supplier, LogisticEmployee, Controller }
    // Mapping to store the roles of the participants and the products
    mapping(address => Role) public roles;
    mapping(uint256 => Product) public products;
    mapping(address => User) public participants;
    // Variables to store the product counter and the fees
    uint256 public productCounter;
    uint256 public addProductFee = 0.01 ether;
    uint256 public updateProductFee = 0.1 ether;
    // Events to log the actions
    event ParticipantAdded(address indexed participant, Role role, string name, string email);
    event ParticipantRemoved(address indexed participant);
    event ProductAdded(uint256 indexed productId, string name, address indexed owner, uint256 quantity, ProductLocation location);
    event ProductUpdated(uint256 indexed productId, address indexed from, address indexed to, ProductLocation location, uint256 quantity);
    /*
        Modifiers that are used to restrict access to certain functions
        only the administrator can add and remove participants
        only the participants can add products
        only the current owner of the product can update the product
        and cost modifier to ensure that the user is serious about adding a product
    */
    modifier onlyRole(Role _role) {
        require(roles[msg.sender] == _role, "Access denied");
        _;
    }

    modifier onlyParticipant() {
        require(participants[msg.sender].walletAddress != address(0), "Not a participant");
        _;
    }

    // Modifier to check if the user has sent enough funds
    modifier costs(uint256 amount) {
        require(msg.value >= amount, "Insufficient funds sent");
        _;
    }
    /*
        Constructor to set the initial administrator of the contract which is the deployer of the contract
    */
    constructor() {
        roles[msg.sender] = Role.Administrator; // Contract deployer is the initial admin
    }
    /*  
        Functions that are related to add and remove participants
        only the administrator can add and remove participants
    */
    function addParticipant(address _participant, Role _role, string memory _name, string memory _email) public onlyRole(Role.Administrator) {
        participants[_participant] = User({
            name: _name,
            email: _email,
            walletAddress: _participant,
            role: _role
        });
        roles[_participant] = _role;
        emit ParticipantAdded(_participant, _role, _name, _email);
    }
    function removeParticipant(address _participant) public onlyRole(Role.Administrator) {
        delete participants[_participant];
        emit ParticipantRemoved(_participant);
    }

    function getParticipant(address _participant) public view returns (User memory) {
        console.log("getParticipant", _participant);
        console.log("participants", participants[_participant].walletAddress);
        console.log("participants", participants[_participant].name);
        console.log("participants", participants[_participant].email);
        console.log("participants", roleToString(participants[_participant].role));

        return participants[_participant];
    }

    function getRole(address _participant) public view returns (string memory) {
        return roleToString(participants[_participant].role);
    }
    /* 
        functions that are related to add and update products
        the cost of adding a product is 0.01 ether to ensure that the user is serious about adding a product
        also the user must be a participant to add a product
        and only the current owner of the product can update the product
    */
    function addProduct(string memory _name, uint256 _quantity, ProductLocation _location) public payable onlyParticipant costs(addProductFee) {
        productCounter++;
        Product storage newProduct = products[productCounter];
        newProduct.name = _name;
        newProduct.currentOwner = msg.sender;
        newProduct.quantity = _quantity;
        newProduct.location = _location;
        emit ProductAdded(productCounter, _name, msg.sender, _quantity, _location);
    }
    function updateProduct(uint256 _productId, address _to, ProductLocation _location, uint256 _quantity) public payable onlyParticipant costs(updateProductFee){
        Product storage product = products[_productId];
        require(product.currentOwner == msg.sender, "Only current owner can update");

        product.shippingHistory.push(ShippingData(product.currentOwner, _to, block.timestamp, locationToString(_location), _quantity));
        product.currentOwner = _to;
        product.location = _location;
        product.quantity = _quantity;

        emit ProductUpdated(_productId, msg.sender, _to, _location, _quantity);
    }
   /*
        functions that helps to restrict the access to the product based on the user role and the product shipping history
        if the user is the controller he can access the product directly
        if the user is the logistic employee he can access the product if the product is up to the logistic warehouse
        if the user is the supplier he can access the product if the product is up to the manufacturer
        if the user is not one of the previous roles he can't access the product
    */
    function getProduct(uint256 _productId) public view returns (Product memory) {
        require(canAccessProduct(_productId), "Access denied");
        return products[_productId];
    }
    // Check if the user has access to the product
    function canAccessProduct(uint256 _productId) internal view returns (bool) {
        if (roles[msg.sender] == Role.Controller) {
            return true;
        } else if (roles[msg.sender] == Role.LogisticEmployee) {
            return checkAccess(_productId, 4); // up to Logistic Warehouse
        } else if (roles[msg.sender] == Role.Supplier) {
            return checkAccess(_productId, 2); // up to Manufacturer
        }
        return false;
    }

    // Check if the user has access to the product based on the shipping history
    function checkAccess(uint256 _productId, uint _maxIndex) internal view returns (bool) {
        Product storage product = products[_productId];
        for (uint i = 0; i < product.shippingHistory.length && i < _maxIndex; i++) {
            if (product.shippingHistory[i].from == msg.sender || product.shippingHistory[i].to == msg.sender) {
                return true;
            }
        }
        return false;
    }

    // Function to get the product shipping history to string array
    function getShippingHistory(uint256 _productId) public view returns (string[] memory) {
        ShippingData[] memory shippingHistory = products[_productId].shippingHistory;
        string[] memory history = new string[](shippingHistory.length);
        for (uint i = 0; i < shippingHistory.length; i++) {
            history[i] = string(abi.encodePacked(
                "From: ", participants[shippingHistory[i].from].name, " To: ", participants[shippingHistory[i].to].name,
                " Location: ", shippingHistory[i].location, " Quantity: ", uint2str(shippingHistory[i].quantity),
                " Timestamp: ", uint2str(shippingHistory[i].timestamp)
            ));
        }
        return history;
    }

    // Function to get the role name
    function roleToString(Role _role) internal pure returns (string memory) {
        if (_role == Role.Administrator) {
            return "Administrator";
        } else if (_role == Role.Supplier) {
            return "Supplier";
        } else if (_role == Role.LogisticEmployee) {
            return "Logistic Employee";
        } else if (_role == Role.Controller) {
            return "Controller";
        } else {
            revert("Invalid role");
        }
    }

    // Function to get the product location
    function locationToString(ProductLocation _location) internal pure returns (string memory) {
        if (_location == ProductLocation.Manufacturer) {
            return "Manufacturer";
        } else if (_location == ProductLocation.Supplier) {
            return "Supplier";
        } else if (_location == ProductLocation.LogisticWarehouse) {
            return "Logistic Warehouse";
        } else if (_location == ProductLocation.Pharmacy) {
            return "Pharmacy";
        } else {
            revert("Invalid location");
        }
    }
    // Ηelper function to convert uint to string
    function uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }

    // Function to withdraw the contract balance
    function withdraw() public onlyRole(Role.Administrator) {
        payable(msg.sender).transfer(address(this).balance);
    }
}
