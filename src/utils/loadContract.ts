// @ts-ignore
import Contract from "@truffle/contract";

export const loadContract = async (name: string, provider: any) => {
  //   raw json file
  const res = await fetch(`contracts/${name}.json`);
  const artifact = await res.json();
  const _contract = Contract(artifact);
  _contract.setProvider(provider);

  const deployedContract = _contract.deployed();

  return deployedContract;
};
