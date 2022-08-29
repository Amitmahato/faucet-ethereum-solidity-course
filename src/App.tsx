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
    providerLoaded: boolean;
  }>({
    provider: null,
    web3: null,
    contract: null,
    providerLoaded: false,
  });

  const [account, setAccount] = useState<string | null>(null);
  const [balance, setBalance] = useState(0);
  const [reload, setReload] = useState(false);

  const refresh = () => setReload(!reload);

  const accountListener = (provider: any) => {
    provider.on("accountsChanged", (_account: string) => {
      // window.location.reload();
      setAccount(_account[0]);
    });

    provider.on("chainChanged", () => {
      window.location.reload();
    });

    // The _jsonRpcConnection is an experimental API and may change in future
    provider._jsonRpcConnection.events.on("notification", (payload: any) => {
      const { method } = payload;
      if (method === "metamask_unlockStateChanged") {
        setAccount(null);
      }
    });
  };

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
        accountListener(provider);
        const contract = await loadContract("Faucet", provider);

        setWeb3Api({
          provider,
          web3: new web3(provider),
          contract,
          providerLoaded: true,
        });
      } else {
        setWeb3Api((web3Api) => ({
          ...web3Api,
          providerLoaded: true,
        }));
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
  }, [web3Api.web3, reload]);

  const connectWallet = async () => {
    if (web3Api.provider) {
      await web3Api.provider.request({
        method: "eth_requestAccounts",
      });
      refresh();
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
  }, [web3Api, reload]);

  const donateFund = async () => {
    const { contract, web3 } = web3Api;
    await contract.addFunds({
      from: account,
      value: web3?.utils.toWei("1", "ether"),
    });
    refresh();
  };

  const withdrawFund = async () => {
    const { contract, web3 } = web3Api;
    await contract.withdraw(web3?.utils.toWei("0.1", "ether"), {
      from: account,
    });
    refresh();
  };

  const isContractLoaded = account && web3Api.contract;

  return (
    <>
      <div className="faucet-wrapper">
        <div className="faucet">
          <span>
            <strong>Account: </strong>
          </span>
          <span>
            {web3Api.providerLoaded ? (
              account ? (
                account
              ) : !web3Api.provider ? (
                <span className="notification is-size-6 is-warning is-rounded">
                  Wallet is not detected!
                  <a
                    className="ml-2"
                    target="_blank"
                    rel="noreferrer"
                    href="https://docs.metamask.io"
                  >
                    Install Metamask
                  </a>
                </span>
              ) : (
                <button className="button is-small" onClick={connectWallet}>
                  Connect Wallet
                </button>
              )
            ) : (
              <span>Loading web3 provider...</span>
            )}
          </span>
          <div className="balance-view is-size-2 my-4">
            Current Balance: <strong>{balance}</strong> ETH
          </div>
          {!web3Api.contract && (
            <div className="notification is-italic mb-2 is-warning">
              You may be connected to the wrong network. Please, connect to{" "}
              <strong>Ganache</strong>!
            </div>
          )}
          <button
            disabled={!isContractLoaded}
            className="button is-link mr-2"
            onClick={donateFund}
          >
            Donate 1 ETH
          </button>
          <button
            disabled={!isContractLoaded}
            className="button is-primary mr-2"
            onClick={withdrawFund}
          >
            Withdraw 0.1 ETH
          </button>
        </div>
      </div>
    </>
  );
}

export default App;
