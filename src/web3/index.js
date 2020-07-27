import Web3 from "web3";
import Web3Modal from "web3modal";
import { providerOptions } from "./config.js";


const web3Modal = new Web3Modal({
    network: "ropsten", // optional
    cacheProvider: true, // optional
    providerOptions // required
  });



const getWeb3 = () => {
    
    return new Promise(async (resolve, reject) => {

        try {

            const provider = await web3Modal.connect();
            const web3 = new Web3(provider);
            // Acccounts now exposed
            resolve(web3);

        } catch (error) {
            reject(error);
        }
    });
}
  
export default getWeb3;