// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract PharmaSupplyChain {
    enum Role { Admin, Supplier, LogisticEmployee, Controller, None }

    address public admin;
    mapping(address => Role) public userRoles;

    struct Product {
        uint256 id;
        string name;
        string currentLocation;
    }

    struct Shipment {
        uint256 id;
        uint256 productId;
        string origin;
        string destination;
        uint256 dateDeparture;
        uint256 expectedArrivalDate;
        string status;
    }

    mapping(uint256 => Product) public products;
    uint256 public productCount;

    mapping(uint256 => Shipment) public shipments;
    uint256 public shipmentCount;

    modifier onlyAdmin() {
        require(userRoles[msg.sender] == Role.Admin, "Access Denied: Only Admin");
        _;
    }

    modifier onlySupplier() {
        require(userRoles[msg.sender] == Role.Supplier, "Access Denied: Incorrect Role");
        _;
    }

    modifier onlyLogisticEmployee() {
        require(userRoles[msg.sender] == Role.LogisticEmployee, "Access Denied: Incorrect Role");
        _;
    }

    constructor() {
        admin = msg.sender;
        userRoles[admin] = Role.Admin;
    }

    function addUser(address _user, string memory _role) external onlyAdmin {
        require(userRoles[_user] == Role.None, "User already exists");

        Role role = Role.None;
        if (keccak256(bytes(_role)) == keccak256(bytes("Supplier"))) {
            role = Role.Supplier;
        } else if (keccak256(bytes(_role)) == keccak256(bytes("LogisticEmployee"))) {
            role = Role.LogisticEmployee;
        } else if (keccak256(bytes(_role)) == keccak256(bytes("Controller"))) {
            role = Role.Controller;
        }

        require(role != Role.None, "Invalid role");

        userRoles[_user] = role;
    }

    function addProduct(string memory _name, string memory _location) external onlySupplier {
        productCount++;
        products[productCount] = Product(productCount, _name, _location);
    }

    function addShipment(uint256 _productId, string memory _origin, string memory _destination, uint256 _dateDeparture, uint256 _expectedArrivalDate) external onlyLogisticEmployee {
        shipmentCount++;
        shipments[shipmentCount] = Shipment(shipmentCount, _productId, _origin, _destination, _dateDeparture, _expectedArrivalDate, "In Transit");
    }

    function updateShipment(uint256 _shipmentId, string memory _status) external onlyLogisticEmployee {
        require(bytes(_status).length > 0, "Status should not be empty");

        shipments[_shipmentId].status = _status;
    }
}
