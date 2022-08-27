import "./App.css";

function App() {
  return (
    <>
      <div className="faucet-wrapper">
        <div className="faucet">
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
