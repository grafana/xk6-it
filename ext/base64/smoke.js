import { check } from "k6";
import { randomBytes } from "k6/crypto";
import { b64encode } from "k6/encoding";
import { encode } from "k6/x/it/base64";

export const options = {
  thresholds: {
    checks: ["rate==1"],
  },
};

export default function () {
  const bytes = randomBytes(20);
  const encoded = encode(bytes);

  check(encoded, {
    it: (str) => str == b64encode(bytes),
  });
}
