// SPDX-License-Identifier: MIT

pragma solidity >0.8.0;

import './Store.sol';

contract StoreCreator {

    // import Store.sol and create new smart contract for new store

    // declare our event here
    event NewStore (string indexed storeName, address indexed storeAddress, address indexed storeOwnerAddress);
    event StoreStatus (address indexed storeOwnerAddress, bool status);

    address public storeCreatorOwnerAddress;

    struct StoreInfo {
        address storeAddress;
        address ownerAddress;
        string storeName;
        bool isActive;
    }

    mapping (address => StoreInfo) userStore;

    modifier onlyOwner {
      require(msg.sender == storeCreatorOwnerAddress);
      _;
   }

    constructor () {
        storeCreatorOwnerAddress = msg.sender;
    }

    function addStore (string memory _storeName) public {
        Store newStore = new Store(msg.sender, _storeName);
        address newStoreAddress = address(newStore);
        userStore[msg.sender] = StoreInfo(newStoreAddress, msg.sender, _storeName, true);
        emit NewStore(_storeName, newStoreAddress, msg.sender);
    }

    function pauseStore () public {
        require(userStore[msg.sender].ownerAddress == msg.sender);
        require(msg.sender == storeCreatorOwnerAddress);
        userStore[msg.sender].isActive = false;
        emit StoreStatus(msg.sender, false);
    }

    function resumeStore () public {
        require(userStore[msg.sender].ownerAddress == msg.sender);
        require(msg.sender == storeCreatorOwnerAddress);
        userStore[msg.sender].isActive = true;
        emit StoreStatus(msg.sender, true);
    }

}