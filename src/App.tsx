import { useEffect, useState } from "react";
import "./App.css";
// @ts-ignore
import web3 from "web3";
/**
 * The issue of `Failed to parse source map ...` related to @metamask/detect-provider
 * will need an update, as mentioned in issue `https://github.com/MetaMask/detect-provider/issues/42#issuecomment-1215848244`
 */
import detectEthereumProvider from "@metamask/detect-provider";
import { loadContract } from "./utils/loadContract";

function App() {
  const [web3Api, setWeb3Api] = useState<{
    provider: any;
    web3: web3 | null;
    contract: any;
  }>({
    provider: null,
    web3: null,
    contract: null,
  });

  const [account, setAccount] = useState<string | null>(null);
  const [balance, setBalance] = useState(0);

  useEffect(() => {
    /**
     * Metamask injects a global API into the website
     * With metamask we have access to `window.ethereum` and `window.web3`
     * These APIs allow websites to request users, accounts, read data to blockchain
     * sign  messages and transactions
     */
    const loadProvider = async () => {
      let provider: any = await detectEthereumProvider();
      const contract = await loadContract("Faucet", provider);
      if (provider) {
        setWeb3Api({
          provider,
          web3: new web3(provider),
          contract,
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
      const accounts = (await web3Api.web3?.eth.getAccounts()) || [];

      setAccount(accounts[0]);
    };

    if (web3Api.web3) {
      getAccount();
    }
  }, [web3Api.web3]);

  const connectWallet = async () => {
    if (web3Api.provider) {
      await web3Api.provider.request({
        method: "eth_requestAccounts",
      });
    }
  };

  useEffect(() => {
    const loadBalance = async () => {
      const { contract, web3 } = web3Api;
      const _balance = await web3?.eth.getBalance(contract.address);
      const ether = web3Api.web3?.utils.fromWei(_balance || "", "ether");
      setBalance(Number(ether));
    };

    if (web3Api.contract) {
      loadBalance();
    }
  }, [web3Api]);

  return (
    <>
      <div className="faucet-wrapper">
        <div className="faucet">
          <span>
            <strong>Account: </strong>
          </span>
          <span>
            {account ? (
              account
            ) : (
              <button className="button is-small" onClick={connectWallet}>
                Connect Wallet
              </button>
            )}
          </span>
          <div className="balance-view is-size-2 mb-4">
            Current Balance: <strong>{balance}</strong> ETH
          </div>
          <button className="button is-link mr-2">Donate</button>
          <button className="button is-primary mr-2">Withdraw</button>
        </div>
      </div>
    </>
  );
}

export default App;
