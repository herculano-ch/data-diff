defmodule DataDiff.Service.CsvParse do

  NimbleCSV.define(CsvParse, separator: ",", escape: "\"")
end
