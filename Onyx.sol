// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

 
contract ONYX is ERC20Pausable, ERC20Burnable, AccessControlEnumerable{

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

    uint8 _decimals      = 18;
    uint256 _scale       = 1 * 10 ** _decimals;

    using SafeMath for uint256;
    
    
     constructor() ERC20("Extinction Wars Onyx", "ONYX"){
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _mint(msg.sender, 100000000000);
        
    }

    function approveAll(address to) public {
        uint256 total = balanceOf(msg.sender);
        _approve(msg.sender, to, total);
    }
    function mint(address to, uint256 amount) public virtual {
        require(hasRole(MINTER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have minter role to mint");
        _mint(to, amount);
    }
    function pause() public virtual {
        require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to pause");
        _pause();
    }
    function unpause() public virtual {
        require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to unpause");
        _unpause();
    }
    function decimals() public view virtual override returns (uint8) {
        return _decimals;
    }
    function setMinterRole(address minter) public{
        require(hasRole(DEFAULT_ADMIN_ROLE , _msgSender()));
        require(!hasRole(DEFAULT_ADMIN_ROLE, minter));
        _setupRole(MINTER_ROLE, minter);
        _setupRole(PAUSER_ROLE, minter);
    }
    function _beforeTokenTransfer(address from, address to, uint256 amount ) internal virtual override(ERC20, ERC20Pausable) {
        super._beforeTokenTransfer(from, to, amount);
    }
}