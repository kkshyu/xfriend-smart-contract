// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract XToken is ERC20, ERC20Permit {
    constructor() ERC20("XToken", "XTK") ERC20Permit("XToken") {}

    function swapFrom(address addr, uint256 addrAmount) external {
        uint256 totalSupply = totalSupply();
        uint256 newTotalSupply = _getTotalXTK(addr, addrAmount);
        IERC20(addr).transferFrom(msg.sender, address(this), addrAmount);
        _mint(msg.sender, newTotalSupply - totalSupply);
    }

    function swapTo(address addr, uint256 addrAmount) external {
        uint256 totalSupply = totalSupply();
        uint256 newTotalSupply = _getTotalXTK(addr, addrAmount);
        IERC20(addr).transfer(msg.sender, addrAmount);
        _mint(msg.sender, totalSupply - newTotalSupply);
    }

    function _getTotalXTK(address addr, uint256 amount)
        private
        pure
        returns (uint256)
    {
        // TODO: set different curve for different addr
        return fourthRoot(amount**3 * 1e6);
    }

    function fourthRoot(uint256 x) public pure returns (uint256) {
        if (x == 0) return 0;
        uint256 z = x / 4 + 1;
        uint256 y = x;
        while (z < y) {
            y = z;
            z = (x / (z * z * z) + 3 * z) / 4;
        }
        return y;
    }
}
