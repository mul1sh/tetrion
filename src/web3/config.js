import Torus from "@toruslabs/torus-embed";
import Authereum from "authereum";
import UniLogin from "@unilogin/provider";

export const providerOptions = {
	torus: {
        package: Torus, // required
    },
    authereum: {
        package: Authereum // required
    },
    unilogin: {
        package: UniLogin // required
    }
};