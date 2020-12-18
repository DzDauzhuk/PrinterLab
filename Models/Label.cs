using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace onceAgainLabForPrinter.Models {
    public class Label {
        public string sampleName { get; set; }
        public string printerName { get; set; }
        public string[,] atributes { get; set; }
    }
}