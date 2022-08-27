import { useEffect, useState } from "react";
import "./App.css";
// @ts-ignore
import web3 from "web3/dist/web3.min.js";

declare var window: any;

function App() {
  const [web3Api, setWeb3Api] = useState<{
    provider: null;
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
      let provider = null;
      if (window.ethereum) {
        provider = window.ethereum;
        try {
          await provider.request({
            method: "eth_requestAccounts",
          });
        } catch (e) {
          console.error("User denied access to metamask accounts: ", e);
        }
      } else if (window.web3) {
        // legacy version of metamask used `window.web3`
        provider = window.web3.currentProvider;
      } else if (!process.env.production) {
        // If not in production mode, use Ganache network provider
        provider = new web3.providers.HttpProvider("localhost:7545");
      }

      setWeb3Api({
        provider,
        web3: new web3(provider),
      });
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
