defmodule PDFTest.Fixture do
  def content do
    """
    \hline
    \footnotesize\textbf{Vehicle Checked in By Officer} &
    \footnotesize\textbf{Printed Name of Driver} &
    \footnotesize\textbf{Firm or Employer} &
    \footnotesize\textbf{Vehicle License Plate Number} &
    \footnotesize\textbf{Arrival/POC Notification Time} &
    \footnotesize\textbf{Primary POC Name} &
    \footnotesize\textbf{Cargo Type} &
    \footnotesize\textbf{Employee Random} &
    \footnotesize\textbf{Search Completed by MSO} &
    \footnotesize\textbf{Entry Time} \\ \hline
    & Joe Smith & WingStop2 & & 01-03-18 14:10 & 352 Test2 & Wings2 & & 3 & 01-03-18 14:25  \\ \hline
    & Joe Smith & 352 WingstopWarehousePA2 & & 01-03-18 14:14 & 352 Warehouse\&PA2 & 352 WingsWarehousePA2 & & F & 01-03-18 15:42 \\ \hline
    & Joe Smith & 352 Wing1 & &  01-03-18 14:18 & Fabian 352Test1 & 352 Wings & & S & 01-03-18 14:25 \\ \hline
    & Joe Smith & 352 WingstopWarehouse1 & & 01-03-18 15:39 & 352 WarehouseTest1 & & 352 WingsWarehouse1 & F & 01-03-18 15:42   \\ \hline
    & Joe Smith & Area 51 & & Academy & Nuclear & & & & \\ \hline
    """
  end
end
