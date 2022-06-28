import { Blob } from 'buffer';
import { readFileSync, promises as fsPromises , writeFileSync}  from 'fs';
import { join } from 'path';
import { of, Observable, pipe} from 'rxjs';
import { inflateRaw, inflate }  from 'pako';
import * as JSZip from 'jszip';
import { file } from 'jszip';
/*const readFile = (file, type) => new Observable<string | BlobPart>(subscriber => {
    //not sure if this func is necessary, or if it complicates
    file.async(type).then(
      result => {
        subscriber.next(result)
        subscriber.complete()
      },
      error => subscriber.error(error)
    )
  })
*/

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
    
/*
    if (isJson) {
      return readFile('string')
        .pipe(
          tap(content => this.loadMapping(content))
        )
    } else {
      return readFile('blob')
        .pipe(
          switchMap(content => {
            const blob = new Blob([content], {type: MediaType.XLSX});
            const reportFile = new File([blob], file.name, {type: MediaType.XLSX});
            return this.loadReport([reportFile]);
          })
        )
    }
*/
//const blob = new Blob([content], {type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'});
//const reportFile = new File([blob], file.name, {type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'});

//generateFile('scan.txt.etl');
//readFile('scan-report.etl');
//getAsByteArray('scan.txt.etl');
const wrapperfunc = async () => {
  const fileconts = readFileSync('scan-report.etl');
  //console.log(fileconts);
  const jszipInstance = new JSZip();
  const unzipped = await jszipInstance.loadAsync(fileconts);
  console.log(unzipped);
  const keys = Object.keys(unzipped.files);
  for (let key of keys) {
    const item = unzipped.files[key];
    writeFileSync(item.name, Buffer.from(await item.async('arraybuffer')));
  }
}

wrapperfunc();