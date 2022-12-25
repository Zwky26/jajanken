import { Blob } from 'buffer';
import { readFileSync, promises as fsPromises , writeFileSync}  from 'fs';
import { join } from 'path';
import { of, Observable, pipe} from 'rxjs';
import { inflateRaw, inflate }  from 'pako';
import * as JSZip from 'jszip';
import { file } from 'jszip';

async function getAsByteArray(name: string) {
  try{
    var filecontents = await fsPromises.readFile(join(__dirname, name));
    var b = new Uint8Array(filecontents);
    //console.log(b);
    return b;
  } catch (err) {
    console.log(err);
    return 'Something went wrong'
  }
}
async function readFile(filename: string) : Promise<string>{
    try {
        const input = await getAsByteArray(filename);
        //console.log(result); 
        //successfully read file
        console.log(input);
        console.log('-----------------------------------');
        const result = inflate(input);
        //const s: string = Buffer.from(result).toString('UTF-8');
        console.log(result)
        return inflateRaw(input);
      } catch (err) {
        console.log(err);
        return 'Something went wrong'
      }
    }
async function generateFile(filename: string) {
    //try to read in file, then generate new file
    console.log("Reading in file...");
    const parsed = await readFile(filename);
    console.log(parsed);

    const blob = new Blob([parsed], {type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'});
    var report = <File>blob;
    fsPromises.writeFile(join(__dirname, "ouput.xlsx"), parsed);
    //const reportFile = new File([blob], 'output.xlsx');
    }
    

const wrapperfunc = async () => {
  const fileconts = readFileSync('err1.etl');
  //console.log(fileconts);
  const jszipInstance = new JSZip();
  const unzipped = await jszipInstance.loadAsync(fileconts);
  //console.log(unzipped);
  const keys = Object.keys(unzipped.files);
  console.log(keys);
  for (let key of keys) {
    const item = unzipped.files[key];
    writeFileSync(item.name, Buffer.from(await item.async('arraybuffer')));
  }
  const mapping = unzipped.files['scan-report.json'];
  console.log(mapping);
}

wrapperfunc();