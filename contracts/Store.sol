// SPDX-License-Identifier: MIT

pragma solidity >0.8.0;

contract Store {
    address owner;

    constructor (address _ownerAddress) {
        owner = _ownerAddress;
    }
}
