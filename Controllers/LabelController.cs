using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace onceAgainLabForPrinter.Controllers {
    public class LabelController : ApiController {
        private string[] labels = { "name1", "name2", "name3" };
        private Printer printer = new Printer();

        [HttpPost, Route("Label")]
        public string PrintLabel(onceAgainLabForPrinter.Models.Label printingLable) {
            Dictionary<string, string> atributes = new Dictionary<string, string>(printingLable.atributes.GetLength(0));
            for(int i = 0; i < printingLable.atributes.GetLength(0); i++) {
                atributes.Add(printingLable.atributes[i, 0], printingLable.atributes[i, 1]);
            }
            printer.PrintSample(printingLable.sampleName, printingLable.printerName, atributes, 1);
            return "ok";
        }

        [HttpGet, Route("Printer")]
        public string[] GetAllPrintersNames() {
            return printer.GetSystemPrinters();
        }

        [HttpGet, Route("Label")]
        public IEnumerable<string> getAllLabels() {
            return printer.GetAllSamplesNames();
        }

        [HttpPost, Route("sample")]
        public Dictionary<string, string> getSampleAtributes(onceAgainLabForPrinter.Models.Label printingLable) {
            return printer.getSampleAtributes(printingLable.sampleName);
        }

    }
}
