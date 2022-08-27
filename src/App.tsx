import { useEffect } from "react";
import "./App.css";

declare var window: any;

function App() {
  useEffect(() => {
    /**
     * Metamask injects a global API into the website
     * With metamask we have access to `window.ethereum` and `window.web3`
     * These APIs allow websites to request users, accounts, read data to blockchain
     * sign  messages and transactions
     */
    const loadProvider = async () => {
      console.log("Ethereum API: ", window.ethereum);
      console.log("Web3 API: ", window.web3);
    };

    loadProvider();
  }, []);

  const enableEthereum = async () => {
    if (window.ethereum) {
      /**
       * This will connect to the metamask and use one of the connected account
       * Upon changing the connected account from the metamask window, same will be reflected in the website
       */
      const accounts = await window.ethereum.request({
        method: "eth_requestAccounts",
      });
      console.log("Accounts: ", accounts);
    }
  };

  return (
    <>
      <div className="faucet-wrapper">
        <div className="faucet">
          <div className="balance-view is-size-2">
            Current Balance: <strong>{124}</strong> ETH
          </div>
          <button className="btn mr-2" onClick={enableEthereum}>
            Enable Ethereum
          </button>
          <button className="btn mr-2">Donate</button>
          <button className="btn mr-2">Withdraw</button>
        </div>
      </div>
    </>
  );
}

export default App;
