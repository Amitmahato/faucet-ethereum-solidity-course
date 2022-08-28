// @ts-ignore
import Contract from "@truffle/contract";

export const loadContract = async (name: string) => {
  //   raw json file
  const res = await fetch(`contracts/${name}.json`);
  const artifact = await res.json();

  return Contract(artifact);
};
