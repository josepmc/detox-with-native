import { getProperties } from "./helper";

describe("Bitfinex Currency Pairs", () => {
  beforeEach(async () => {
    await device.launchApp({});
  });

  it("should load currency pairs", async () => {
    // We don't have any accessibility id's - if there's localization this will crash
    // badly
    await expect(element(by.text("Currency Pairs"))).toBeVisible();
  });

  it("should load first the pair on click", async () => {
    let pair = await element(by.type("UITableViewLabel")).atIndex(1);
    let properties = await getProperties(pair);
    await pair.tap();
    await expect(
      element(by.type("UILabel").and(by.text(properties.text)))
    ).toBeVisible();
    await expect(element(by.text("CONNECTED"))).toExist();
  });

  it("should go back", async () => {
    await element(by.text("Currency Pairs")).tap();
    await expect(element(by.text("Currency Pairs"))).toBeVisible();
    await expect(element(by.type("UITableViewLabel")).atIndex(1)).toBeVisible();
  });
});
