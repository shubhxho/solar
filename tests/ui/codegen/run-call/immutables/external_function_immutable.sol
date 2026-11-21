//@ revisions: default gas size
//@[gas] compile-flags: -O gas
//@[size] compile-flags: -O size
//@ run-call: ExternalFunctionImmutable::callIt => 7
//@ run-call: ExternalFunctionImmutable::accountIsThis => true
//@ run-call: ExternalFunctionImmutable::sel => 0x6d4ce63c
//@ run-call: Other::callIt => 42
//@ run-call: Other::pointsAtTarget => true
//@ run-call: Other::sel => 0x6d4ce63c

// External function immutables: construct from `this` and from `new`, then call
// and read `.address` / `.selector`.
contract ExternalFunctionImmutable {
    function() external pure returns (uint256) immutable fn = this.get;

    function get() external pure returns (uint256) {
        return 7;
    }

    function callIt() external view returns (uint256) {
        return fn();
    }

    function accountIsThis() external view returns (bool) {
        return fn.address == address(this);
    }

    function sel() external view returns (bytes4) {
        return fn.selector;
    }
}

contract Target {
    function get() external pure returns (uint256) {
        return 42;
    }
}

contract Other {
    function() external pure returns (uint256) immutable fn;
    address immutable target;

    constructor() {
        Target deployed = new Target();
        target = address(deployed);
        fn = deployed.get;
    }

    function callIt() external view returns (uint256) {
        return fn();
    }

    function pointsAtTarget() external view returns (bool) {
        return fn.address == target;
    }

    function sel() external view returns (bytes4) {
        return fn.selector;
    }
}
