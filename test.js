"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __generator = (this && this.__generator) || function (thisArg, body) {
    var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g;
    return g = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
    function verb(n) { return function (v) { return step([n, v]); }; }
    function step(op) {
        if (f) throw new TypeError("Generator is already executing.");
        while (_) try {
            if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 0) : y.next) && !(t = t.call(y, op[1])).done) return t;
            if (y = 0, t) op = [op[0] & 2, t.value];
            switch (op[0]) {
                case 0: case 1: t = op; break;
                case 4: _.label++; return { value: op[1], done: false };
                case 5: _.label++; y = op[1]; op = [0]; continue;
                case 7: op = _.ops.pop(); _.trys.pop(); continue;
                default:
                    if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                    if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                    if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                    if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                    if (t[2]) _.ops.pop();
                    _.trys.pop(); continue;
            }
            op = body.call(thisArg, _);
        } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
        if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
    }
};
exports.__esModule = true;
var buffer_1 = require("buffer");
var fs_1 = require("fs");
var path_1 = require("path");
var pako_1 = require("pako");
var JSZip = require("jszip");
function getAsByteArray(name) {
    return __awaiter(this, void 0, void 0, function () {
        var filecontents, b, err_1;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0:
                    _a.trys.push([0, 2, , 3]);
                    return [4 /*yield*/, fs_1.promises.readFile((0, path_1.join)(__dirname, name))];
                case 1:
                    filecontents = _a.sent();
                    b = new Uint8Array(filecontents);
                    //console.log(b);
                    return [2 /*return*/, b];
                case 2:
                    err_1 = _a.sent();
                    console.log(err_1);
                    return [2 /*return*/, 'Something went wrong'];
                case 3: return [2 /*return*/];
            }
        });
    });
}
function readFile(filename) {
    return __awaiter(this, void 0, void 0, function () {
        var input, result, err_2;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0:
                    _a.trys.push([0, 2, , 3]);
                    return [4 /*yield*/, getAsByteArray(filename)];
                case 1:
                    input = _a.sent();
                    //console.log(result); 
                    //successfully read file
                    console.log(input);
                    console.log('-----------------------------------');
                    result = (0, pako_1.inflate)(input);
                    //const s: string = Buffer.from(result).toString('UTF-8');
                    console.log(result);
                    return [2 /*return*/, (0, pako_1.inflateRaw)(input)];
                case 2:
                    err_2 = _a.sent();
                    console.log(err_2);
                    return [2 /*return*/, 'Something went wrong'];
                case 3: return [2 /*return*/];
            }
        });
    });
}
function generateFile(filename) {
    return __awaiter(this, void 0, void 0, function () {
        var parsed, blob, report;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0:
                    //try to read in file, then generate new file
                    console.log("Reading in file...");
                    return [4 /*yield*/, readFile(filename)];
                case 1:
                    parsed = _a.sent();
                    console.log(parsed);
                    blob = new buffer_1.Blob([parsed], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' });
                    report = blob;
                    fs_1.promises.writeFile((0, path_1.join)(__dirname, "ouput.xlsx"), parsed);
                    return [2 /*return*/];
            }
        });
    });
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
var wrapperfunc = function () { return __awaiter(void 0, void 0, void 0, function () {
    var fileconts, jszipInstance, unzipped, keys, _i, keys_1, key, item, _a, _b, _c, _d, mapping;
    return __generator(this, function (_e) {
        switch (_e.label) {
            case 0:
                fileconts = (0, fs_1.readFileSync)('err1.etl');
                jszipInstance = new JSZip();
                return [4 /*yield*/, jszipInstance.loadAsync(fileconts)];
            case 1:
                unzipped = _e.sent();
                keys = Object.keys(unzipped.files);
                console.log(keys);
                _i = 0, keys_1 = keys;
                _e.label = 2;
            case 2:
                if (!(_i < keys_1.length)) return [3 /*break*/, 5];
                key = keys_1[_i];
                item = unzipped.files[key];
                _a = fs_1.writeFileSync;
                _b = [item.name];
                _d = (_c = Buffer).from;
                return [4 /*yield*/, item.async('arraybuffer')];
            case 3:
                _a.apply(void 0, _b.concat([_d.apply(_c, [_e.sent()])]));
                _e.label = 4;
            case 4:
                _i++;
                return [3 /*break*/, 2];
            case 5:
                mapping = unzipped.files['scan-report.json'];
                console.log(mapping);
                return [2 /*return*/];
        }
    });
}); };
wrapperfunc();
