// contracts/FarmXTokenV2.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20VotesUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20CappedUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20BurnableUpgradeable.sol";

contract FarmXTokenV1 is ERC20VotesUpgradeable, ERC20CappedUpgradeable, ERC20BurnableUpgradeable {

    string internal constant NAME = "FarmX Token";
    string internal constant SYMBOL = "FARMX";

    function initialize() initializer public {

        __ERC20_init(NAME, SYMBOL);
        __ERC20Permit_init(NAME);

        uint256 initialSupply = 100_000_000 * (10 ** decimals());

        // Cap total tokens to initialSupply
        __ERC20Capped_init(initialSupply);

        // Distribute FARMX tokens to separate wallets according to tokenomics

        // Seed Round - 6%
        _mint(address(0xa313d703b1B9213A0e4c0d0D1f3a738D98947151), initialSupply * 6 / 100);
        // Private Round - 9%
        _mint(address(0xE278bCA0994d905489b2C652D92dbaCE7FC61d38), initialSupply * 9 / 100);
        // Strategic Round - 2%
        _mint(address(0x477D67800b796D081e33fbdfE71e6710f213a929), initialSupply * 2 / 100);
        // Public Sale - 2%
        _mint(address(0xDB7D5f5e4A25D3222Bca4215cfe8D83C55e8AC33), initialSupply * 2 / 100);
        // DEX Liquidity - 1%
        _mint(address(0x92AC0C00d461172dd8Bf3b51aD05721DE341B111), initialSupply * 1 / 100);
        // Team - 15%
        _mint(address(0x806a43B9965eb0A9188B772D36151Eb2C3e5c5c3), initialSupply * 15 / 100);
        // Advisors - 7%
        _mint(address(0xFc1924fD290FB5E23268B2aF29799aA16256C4Dc), initialSupply * 7 / 100);
        // Staking Rewards - 10%
        _mint(address(0xAB8E4d0281C2f7306c4243227eFC9ef2Ea72675D), initialSupply * 10 / 100);
        // Marketing - 15%
        _mint(address(0xd669EbB9003D3d918E507412fDDdfF473F5FFC07), initialSupply * 15 / 100);
        // Usage rewards - 33%
        _mint(address(0x73751458C193540DbE2Fc621aE208d9762C3BeAd), initialSupply * 33 / 100);

    }

    function _mint(address account, uint256 amount) internal virtual override(ERC20Upgradeable, ERC20CappedUpgradeable, ERC20VotesUpgradeable) {
        require(ERC20Upgradeable.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
        ERC20VotesUpgradeable._mint(account, amount);
    }

    function _burn(address account, uint256 amount) internal virtual override(ERC20Upgradeable, ERC20VotesUpgradeable) {
        ERC20VotesUpgradeable._burn(account, amount);
    }

    function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20Upgradeable, ERC20VotesUpgradeable) {
        ERC20VotesUpgradeable._afterTokenTransfer(from,to,amount);
    }
}