// SPDX-License-Identifier: AEL
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "../TNT.sol";

/// @dev Test helper: tries to burn a token during the ERC721 receive hook.
/// With _safeMint this callback runs and leaves a ghost active token; with
/// _mint the callback is never invoked, which the regression test asserts.
contract ReentrantReceiver is IERC721Receiver {
    TNT public immutable tnt;
    bool public callbackCalled;

    constructor(address _tnt) {
        tnt = TNT(_tnt);
    }

    function onERC721Received(address, address, uint256 tokenId, bytes calldata) external override returns (bytes4) {
        callbackCalled = true;
        tnt.burnToken(tokenId);
        return this.onERC721Received.selector;
    }
}
