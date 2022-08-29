// @ts-ignore
import Contract from "@truffle/contract";

export const loadContract = async (name: string, provider: any) => {
  let deployedContract = null;
  try {
    //   raw json file
    const res = await fetch(`contracts/${name}.json`);
    const artifact = await res.json();

    const _contract = Contract(artifact);
    await _contract.setProvider(provider);
    deployedContract = await _contract.deployed();
  } catch (err) {
    console.error(
      "Failed to get the contract, you may be connected to the wrong network.\nError: ",
      err
    );
  }
  return deployedContract;
};
