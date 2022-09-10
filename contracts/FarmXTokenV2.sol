// contracts/FarmXTokenV2.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20VotesUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20CappedUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "hardhat/console.sol";

contract FarmXTokenV2 is ERC20VotesUpgradeable, ERC20CappedUpgradeable, ERC20BurnableUpgradeable, AccessControlUpgradeable {

    string internal constant NAME = "FarmX Token";
    string internal constant SYMBOL = "FARMX";

    address internal constant SEED_ROUND_WALLET = 0xa313d703b1B9213A0e4c0d0D1f3a738D98947151;
    address internal constant PRIVATE_ROUND_WALLET = 0xE278bCA0994d905489b2C652D92dbaCE7FC61d38;
    address internal constant STRATEGIC_ROUND_WALLET = 0x477D67800b796D081e33fbdfE71e6710f213a929;
    address internal constant PUBLIC_ROUND_WALLET = 0xDB7D5f5e4A25D3222Bca4215cfe8D83C55e8AC33;
    address internal constant DEX_LIQUIDITY_WALLET = 0x92AC0C00d461172dd8Bf3b51aD05721DE341B111;
    address internal constant TEAM_WALLET = 0x806a43B9965eb0A9188B772D36151Eb2C3e5c5c3;
    address internal constant ADVISORS_WALLET = 0xFc1924fD290FB5E23268B2aF29799aA16256C4Dc;
    address internal constant STAKING_REWARDS_WALLET = 0xAB8E4d0281C2f7306c4243227eFC9ef2Ea72675D;
    address internal constant MARKETING_WALLET = 0xd669EbB9003D3d918E507412fDDdfF473F5FFC07;
    address internal constant USAGE_REWARDS_WALLET = 0x73751458C193540DbE2Fc621aE208d9762C3BeAd;

    function initialize() initializer public {
        __ERC20_init(NAME, SYMBOL);
        __ERC20Permit_init(NAME);

        uint256 initialSupply = 100_000_000 * (10 ** decimals());

        // Cap total tokens to initialSupply
        __ERC20Capped_init(initialSupply);

        // Distribute FARMX tokens to separate wallets according to tokenomics

        // Seed Round - 6%
        _mint(address(SEED_ROUND_WALLET), initialSupply * 6 / 100);
        // Private Round - 9%
        _mint(address(PRIVATE_ROUND_WALLET), initialSupply * 9 / 100);
        // Strategic Round - 2%
        _mint(address(STRATEGIC_ROUND_WALLET), initialSupply * 2 / 100);
        // Public Sale - 2%
        _mint(address(PUBLIC_ROUND_WALLET), initialSupply * 2 / 100);
        // DEX Liquidity - 1%
        _mint(address(DEX_LIQUIDITY_WALLET), initialSupply * 1 / 100);
        // Team - 15%
        _mint(address(TEAM_WALLET), initialSupply * 15 / 100);
        // Advisors - 7%
        _mint(address(ADVISORS_WALLET), initialSupply * 7 / 100);
        // Staking Rewards - 10%
        _mint(address(STAKING_REWARDS_WALLET), initialSupply * 10 / 100);
        // Marketing - 15%
        _mint(address(MARKETING_WALLET), initialSupply * 15 / 100);
        // Usage rewards - 33%
        _mint(address(USAGE_REWARDS_WALLET), initialSupply * 33 / 100);
    }

    function burnBridgeTokensAndUpdateDistribution() reinitializer(2) public {
        console.log("burnBridgeTokensAndUpdateDistribution called, sender=", _msgSender());
        _grantRole(DEFAULT_ADMIN_ROLE, address(0x1cc2E400CbB456fcF8a03386397A56AC1c535B28));
        _burnBridgeTokensAndUpdateDistribution();
    }

    function _burnBridgeTokensAndUpdateDistribution() internal {
        // Burn test tokens minted on Polygon, will mint on other chains
        console.log("block number:", block.number);

        uint256 totalBurned = 0;
        totalBurned += _burnBridgeTokensFromAddress(address(0xaabf8b40BfB67261093EB586d2Af449D1D072b70));
        totalBurned += _burnBridgeTokensFromAddress(address(0x842F46E31b3Ee098303C8A0db6c49b0034A8E00f));
        totalBurned += _burnBridgeTokensFromAddress(address(0xE56eAC89cF1A9C36b88Ecbc78fe24E7f01c60A86));
        totalBurned += _burnBridgeTokensFromAddress(address(0xE59F13CF227c3F46C4F710710Cf3C8A457F45db0));
        totalBurned += _burnBridgeTokensFromAddress(address(0x914d39387995EBE72Aa6EbC84917833d99c436A6));
        _burn(USAGE_REWARDS_WALLET, 3200000 ether); // 3.2M tokens burned from usage rewards wallet
        totalBurned += 3200000 ether;
        _burn(MARKETING_WALLET, 9000000 ether); // 9M tokens burned from marketing wallet
        totalBurned += 9000000 ether;

        console.log("totalBurned %s.%s", totalBurned/1 ether, totalBurned%1 ether);
        uint256 usageBalance = balanceOf(USAGE_REWARDS_WALLET);
        console.log("balanceOf(Usage rewards)=%s.%s", usageBalance/1 ether, usageBalance%1 ether);

        uint256 initialSupply = 100_000_000 * (10 ** decimals());

        // Transfer to update tokenomics distribution
        _transfer(SEED_ROUND_WALLET, PUBLIC_ROUND_WALLET, initialSupply * 15/1000); // Move 1.5% from Seed to Public
        _transfer(PRIVATE_ROUND_WALLET, STAKING_REWARDS_WALLET, initialSupply * 5/100); // Move 5% from Private to Staking
        _transfer(STRATEGIC_ROUND_WALLET, MARKETING_WALLET, initialSupply * 1/100); // Move 1% from Strategic to Marketing

        console.log("totalSupply=%s.%s", totalSupply()/1 ether, totalSupply()%1 ether);
        console.log("SEED_ROUND_WALLET      balance %s.%s", balanceOf(SEED_ROUND_WALLET)/1 ether, balanceOf(SEED_ROUND_WALLET)%1 ether);
        console.log("PRIVATE_ROUND_WALLET   balance %s.%s", balanceOf(PRIVATE_ROUND_WALLET)/1 ether, balanceOf(PRIVATE_ROUND_WALLET)%1 ether);
        console.log("STRATEGIC_ROUND_WALLET balance %s.%s", balanceOf(STRATEGIC_ROUND_WALLET)/1 ether, balanceOf(STRATEGIC_ROUND_WALLET)%1 ether);
        console.log("PUBLIC_ROUND_WALLET    balance %s.%s", balanceOf(PUBLIC_ROUND_WALLET)/1 ether, balanceOf(PUBLIC_ROUND_WALLET)%1 ether);
        console.log("DEX_LIQUIDITY_WALLET   balance %s.%s", balanceOf(DEX_LIQUIDITY_WALLET)/1 ether, balanceOf(DEX_LIQUIDITY_WALLET)%1 ether);
        console.log("TEAM_WALLET            balance %s.%s", balanceOf(TEAM_WALLET)/1 ether, balanceOf(TEAM_WALLET)%1 ether);
        console.log("ADVISORS_WALLET        balance %s.%s", balanceOf(ADVISORS_WALLET)/1 ether, balanceOf(ADVISORS_WALLET)%1 ether);
        console.log("STAKING_REWARDS_WALLET balance %s.%s", balanceOf(STAKING_REWARDS_WALLET)/1 ether, balanceOf(STAKING_REWARDS_WALLET)%1 ether);
        console.log("MARKETING_WALLET       balance %s.%s", balanceOf(MARKETING_WALLET)/1 ether, balanceOf(MARKETING_WALLET)%1 ether);
        console.log("USAGE_REWARDS_WALLET   balance %s.%s", balanceOf(USAGE_REWARDS_WALLET)/1 ether, balanceOf(USAGE_REWARDS_WALLET)%1 ether);
    }

    function _burnBridgeTokensFromAddress(address addr) internal returns (uint256) {
        uint256 balanceBefore = balanceOf(addr);
        console.log("balanceOf(%s)=%s.%s", addr, balanceBefore/1 ether, balanceBefore%1 ether);
        _burn(addr, balanceBefore);
        uint256 balanceAfter = balanceOf(addr);
        console.log("balanceOf(%s)=%s.%s", addr, balanceAfter/1 ether, balanceAfter%1 ether);
        return balanceBefore;
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