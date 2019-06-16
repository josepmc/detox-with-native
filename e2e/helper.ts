// TODO: Convert this into a class and break field 'E'
interface IOSError {
  // General message stating the error
  Description: string;
  "Description Glossary": {
    // Element (including attributes)
    E: string;
    // Full Matcher
    M: string;
    // Specific matcher error
    S: string;
  };
  // Totally irrelevant - relative to EarlGrey
  "Error Code": string;
  "Error Domain": string;
  "File Name": string;
  "Function Name": string;
  Line: string;
}

export class EarlGreyElement {
  private static ErrorRegex = /Error Trace: \[\s*([\s\S]*)\]\s*Hierarchy/g;
  public error: IOSError;
  public type: string;
  public text: string;
  public props: { [k: string]: string | boolean | number } = {};
  constructor(public message: string) {
    const matches = EarlGreyElement.ErrorRegex.exec(message);
    if (!matches || matches.length < 2)
      throw new Error(`No matches found for message: ${message}`);
    this.error = JSON.parse(matches[1]);
    let cleanedError = /^<(.*)>$/.exec(this.error["Description Glossary"].E);
    if (!cleanedError || cleanedError.length < 2)
      throw new Error(
        `Element has an invalid format: ${this.error["Description Glossary"].E}`
      );
    let types = cleanedError[1].split(";");
    // First entry is always the type
    this.type = types[0].split(":")[0];
    for (let i = 1; i < types.length; ++i) {
      const [key, value] = types[i].trim().split("=");
      if (value) {
        let p = value.replace(/^'/, "").replace(/'$/, "");
        let number = parseInt(p);
        if (number.toString() === p) this.props[key] = number;
        else this.props[key] = p;
      } else this.props[key] = true;
    }
    this.text = this.props.text.toString();
  }
}

// TODO: Make this prettier
export async function getProperties(
  testID: Detox.Element
): Promise<EarlGreyElement> {
  try {
    await expect(testID).toHaveText("_read_element_error");
  } catch (error) {
    if (device.getPlatform() === "ios") {
      return new EarlGreyElement(error.message);
    } else {
      console.log(`platform is : ${device.getPlatform()}`);
      // TODO
      const start = "Got:";
      const end = '}"';
      const errorMessage = error.message.toString();
      const [, restMessage] = errorMessage.split(start);
      const [label] = restMessage.split(end);
      const value = label.split(",");
      var combineText = value.find(i => i.includes("text=")).trim();
      const [, elementText] = combineText.split("=");
      console.log(combineText);
      return elementText;
    }
  }
}
