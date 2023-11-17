// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

pragma solidity ^0.8.0;

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

pragma solidity ^0.8.0;

contract VerifySignature is Ownable {
    address public _signer;

    // Constructor
    constructor(address signer) {
        _signer = signer;
    }

    function setSigner(address signer) public onlyOwner {
        _signer = signer;
    }

    function getSigner() public view returns (address) {
        return _signer;
    }

    function verifyMessage(
        address user,
        uint userId,
        uint nonce,
        uint blockNumber,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    ) public view returns (bool) {
        bytes memory ethPrefix = "\x19Ethereum Signed Message:\n32";
        bytes32 hash = keccak256(abi.encode(user, userId, nonce, blockNumber));
        bytes32 fullHash = keccak256(abi.encodePacked(ethPrefix, hash));
        address signer = ecrecover(fullHash, _v, _r, _s);
        return signer == _signer;
    }

    function getMessage(
        uint userId,
        uint nonce,
        uint blockNumber,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    ) public view returns (address) {
        bytes memory ethPrefix = "\x19Ethereum Signed Message:\n32";
        bytes32 hash = keccak256(
            abi.encode(msg.sender, userId, nonce, blockNumber)
        );
        bytes32 fullHash = keccak256(abi.encodePacked(ethPrefix, hash));
        address signer = ecrecover(fullHash, _v, _r, _s);
        return signer;
    }
}
