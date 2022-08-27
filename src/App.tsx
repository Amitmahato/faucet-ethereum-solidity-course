import { useEffect, useState } from "react";
import "./App.css";
// @ts-ignore
import web3 from "web3/dist/web3.min.js";

/**
 * The issue of `Failed to parse source map ...` related to @metamask/detect-provider
 * will need an update, as mentioned in issue `https://github.com/MetaMask/detect-provider/issues/42#issuecomment-1215848244`
 */
import detectEthereumProvider from "@metamask/detect-provider";

function App() {
  const [web3Api, setWeb3Api] = useState<{
    provider: any;
    web3: web3 | null;
  }>({
    provider: null,
    web3: null,
  });

  const [account, setAccount] = useState(null);

  useEffect(() => {
    /**
     * Metamask injects a global API into the website
     * With metamask we have access to `window.ethereum` and `window.web3`
     * These APIs allow websites to request users, accounts, read data to blockchain
     * sign  messages and transactions
     */
    const loadProvider = async () => {
      let provider: any = await detectEthereumProvider();

      if (provider) {
        await provider.request({
          method: "eth_requestAccounts",
        });

        setWeb3Api({
          provider,
          web3: new web3(provider),
        });
      } else {
        console.error("Please, Install Metamask");
      }
    };

    loadProvider();
  }, []);

  useEffect(() => {
    const getAccount = async () => {
      // will return a list of accounts, but only connected one at 0th index
      const accounts = await web3Api.web3.eth.getAccounts();

      setAccount(accounts[0]);
    };

    if (web3Api.web3) {
      getAccount();
    }
  }, [web3Api.web3]);

  return (
    <>
      <div className="faucet-wrapper">
        <div className="faucet">
          <span>
            <strong>Account</strong>
          </span>
          <h1>{account ? account : "not connected"}</h1>
          <div className="balance-view is-size-2">
            Current Balance: <strong>{124}</strong> ETH
          </div>
          <button className="btn mr-2">Donate</button>
          <button className="btn mr-2">Withdraw</button>
        </div>
      </div>
    </>
  );
}

export default App;
