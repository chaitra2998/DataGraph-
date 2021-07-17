//
//  DataViewController.swift
//  DataGraph
//
//  Created by Chaitrali chaudhari  on 17/07/21.
//

import UIKit

class DataViewController: UIViewController, UITextFieldDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var CollectionView: UICollectionView!
    @IBOutlet weak var Filters: UISegmentedControl!
    
    //Structs
    var All : [DetailedParams] = [DetailedParams]()
    var shortData : [DetailedParams] = [DetailedParams]()
    var longData : [DetailedParams] = [DetailedParams]()
    var longUnwindingData : [DetailedParams] = [DetailedParams]()
    var shortCoveringData : [DetailedParams] = [DetailedParams]()
    var selectedArray : [DetailedParams] = [DetailedParams]()
    var FiltereddArray : [DetailedParams] = [DetailedParams]()
    
    var companyDataModel : CompanyDataBaseClass?

    @IBAction func filterChnaged(_ sender: Any) {
        searchBar.searchTextField.text = ""
        switch Filters.selectedSegmentIndex
        {
        case 0:
            print("All")
            selectedArray = All
            CollectionView.reloadData()
        case 1:
            print("Long")
            selectedArray = longData
            CollectionView.reloadData()
            
            
        case 2:
            print("short Covering")
            selectedArray = shortCoveringData
            CollectionView.reloadData()
            
            
        case 3:
            print("short")
            selectedArray = shortData
            CollectionView.reloadData()
            
            
        case 4:
            print("Long Unwinding")
            selectedArray = longUnwindingData
            CollectionView.reloadData()
            
            
        default:
            break
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        companyDataSource()
        
        searchBar.searchTextField.delegate = self

        setIAV()
    }
    
   //Loading View
    var messageFrame = UIView()
    var activityIndicatormsg = UIActivityIndicatorView()
    var strLabel = UILabel()

    func progressBarDisplayer(_ msg:String, _ indicator:Bool ) {
        
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
        strLabel.text = msg
        strLabel.textColor = UIColor.white
        messageFrame = UIView(frame: CGRect(x: view.frame.midX - (strLabel.sizeThatFits( CGSize( width: CGFloat.greatestFiniteMagnitude , height: CGFloat.greatestFiniteMagnitude ) ).width) / 2 - 38, y: view.frame.midY - 25 , width: strLabel.sizeThatFits( CGSize( width: CGFloat.greatestFiniteMagnitude , height: CGFloat.greatestFiniteMagnitude ) ).width + 76 , height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.center = CGPoint(x: self.view.center.x , y: self.view.center.y - (self.navigationController?.navigationBar.frame.height ?? 0) - (self.navigationController?.navigationBar.frame.origin.y ?? 0) )
        
        //self.view.center
        messageFrame.backgroundColor = UIColor.black
        if indicator {
            activityIndicatormsg = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.white)
            activityIndicatormsg.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicatormsg.startAnimating()
            messageFrame.addSubview(activityIndicatormsg)
        }
        messageFrame.addSubview(strLabel)
        view.addSubview(messageFrame)
        
    }
    
    func setIAV()
    {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.default
        toolBar.tintColor = HelpingMethods.hexStringToUIColor(hex: AppConstants.whiteBackgroundColor)
        toolBar.backgroundColor = HelpingMethods.hexStringToUIColor(hex: AppConstants.whiteBackgroundColor)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(DataViewController.donePressed(_:)))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let color1 = UIColor.black
        doneButton.tintColor = HelpingMethods.hexStringToUIColor(hex: AppConstants.whiteBackgroundColor)
        toolBar.setItems([flexSpace,doneButton], animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if(textField == self.searchBar.searchTextField){
            filterContentForSearchText(searchText: textField.text ?? "")
        }
        
        return true
    }
    
    @objc func donePressed(_ sender: AnyObject)
    {
        self.view.endEditing(true)
    }
    
    func filterContentForSearchText(searchText: String) {
        FiltereddArray = []
        for item in selectedArray{
            if (item.companyName).lowercased().contains(searchText.lowercased()){
                FiltereddArray.append(item)
            }
            
        }
        selectedArray = FiltereddArray
        CollectionView.reloadData()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string.count == 0){
            filterChnaged(self)
        }
        return true
    }

    
    
    func companyDataSource(){
        let session = URLSession.shared
        let url = URL(string: AppConstants.APIURL)
        if(messageFrame.superview == nil){
            progressBarDisplayer("Loading..", true)
        }
        let task = session.dataTask(with: url!, completionHandler: { data, response, error  in
            
//            print(data)
//            print(response)
//            print(error)
//            print(response)
            
            
            if error != nil {
                // HERE you can manage the error
                self.messageFrame.removeFromSuperview()
                let emptyLabel: UILabel = UILabel() as UILabel
                emptyLabel.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
                emptyLabel.text = "Server Error"
                emptyLabel.textAlignment = .center
                emptyLabel.textColor = HelpingMethods.hexStringToUIColor(hex: AppConstants.whiteBackgroundColor)
                emptyLabel.backgroundColor = UIColor.black
                self.CollectionView.backgroundView = emptyLabel

                print(error)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse{
                if (httpResponse.statusCode) != 200 {
                    self.messageFrame.removeFromSuperview()
                    let emptyLabel: UILabel = UILabel() as UILabel
                    emptyLabel.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
                    emptyLabel.text = "Server Error"
                    emptyLabel.textAlignment = .center
                    emptyLabel.textColor = HelpingMethods.hexStringToUIColor(hex: AppConstants.whiteBackgroundColor)
                    emptyLabel.backgroundColor = UIColor.black
                    self.CollectionView.backgroundView = emptyLabel

                }
             }

            do {
                if let data = data{
                    self.companyDataModel = try JSONDecoder().decode(CompanyDataBaseClass.self, from: data)
                    
                }
                
                print(self.companyDataModel)
                self.spiltData(completionHandler: {
                    self.quickSort(array: &self.All, startIndex: 0, endIndex: self.All.count - 1)
                    
                    print("Sorted: \(self.All)")
                })
                
                for i in 0..<self.All.count{
                    
                    if self.All[i].type == AppConstants.shortType{
                        self.shortData.append(self.All[i])
                    }
                    else if self.All[i].type == AppConstants.longType{
                        self.longData.append(self.All[i])
                    }
                    else if self.All[i].type == AppConstants.shortCoveringType{
                        self.shortCoveringData.append(self.All[i])
                    }
                    else if self.All[i].type == AppConstants.LongUnwindingType{
                        self.longUnwindingData.append(self.All[i])
                    }
                    
                    
                }
                
            //Default Selected Tab
                DispatchQueue.main.async {
                    self.messageFrame.removeFromSuperview()
                    self.Filters.selectedSegmentIndex = 0
                    self.selectedArray = self.All
                    self.CollectionView.reloadData()
                }
                
                
                
                
            }
            catch {
                print("Error during JSON serialization: \(error.localizedDescription)")
            }
            
            
        })
        task.resume()
        
    }
    
    
  // Split Data
    func spiltData(completionHandler:()->Void){
        var AllData : [String] = [String]()
        
        if self.companyDataModel != nil && self.companyDataModel?.short != nil {
            AllData = []
            AllData.append(contentsOf: (self.companyDataModel?.short ?? "").components(separatedBy: ";"))
            initStruct(color: AppConstants.short, baseType: AppConstants.shortType, typeArray: AllData)
            
        }
        if self.companyDataModel != nil && self.companyDataModel?.shortCovering != nil {
            AllData = []
            AllData.append(contentsOf: (self.companyDataModel?.shortCovering ?? "").components(separatedBy: ";"))
            initStruct(color: AppConstants.shortCovering, baseType: AppConstants.shortCoveringType, typeArray: AllData)
            
            
        }
        if self.companyDataModel != nil && self.companyDataModel?.long != nil {
            AllData = []
            AllData.append(contentsOf: (self.companyDataModel?.long ?? "").components(separatedBy: ";"))
            initStruct(color: AppConstants.long, baseType: AppConstants.longType, typeArray: AllData)
            
            
        }
        if self.companyDataModel != nil && self.companyDataModel?.longUnwinding != nil {
            AllData = []
            AllData.append(contentsOf: (self.companyDataModel?.longUnwinding ?? "").components(separatedBy: ";"))
            initStruct(color: AppConstants.LongUnwindingColorCode, baseType: AppConstants.LongUnwindingType, typeArray: AllData)
        }
        
        
        completionHandler()
    }
   
    //Split Data in Dettail
    func initStruct(color : String, baseType : String, typeArray : [String]){
        for detail in typeArray{
            var temp = detail.components(separatedBy: ",")
            All.append(DetailedParams(companyName: temp[0], priceChange: Double(temp[3]) ?? 0.0, color: color, type: baseType))
        }
    }
    
   //Sort in Descending Order
    func quickSort<T: Comparable>(array: inout [T], startIndex: Int, endIndex: Int) {
        // Base case
        if startIndex >= endIndex {
            return
        }
        let placedItemIndex = partition(array: &array, startIndex: startIndex, endIndex: endIndex)
        quickSort(array: &array, startIndex: startIndex, endIndex: placedItemIndex-1)
        quickSort(array: &array, startIndex: placedItemIndex+1, endIndex: endIndex)
        
        
    }
    
    func partition<T: Comparable>(array: inout [T], startIndex: Int, endIndex: Int) -> Int {
        let a = array[startIndex]
        var up = endIndex
        var down = startIndex
        
        while down < up {
            while array[down] >= a && down < endIndex{
                down = down + 1
            }
            while array[up] < a {
                up = up - 1
            }
            
            if down < up {
                var temp = array[down]
                array[down] = array[up]
                array[up] = temp
            }
            
            
        }
        array[startIndex] = array[up]
        array[up] = a
        
        return up
    }
    
    
    
}



extension DataViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ( self.view.frame.size.width * 0.3 ) ,height:( self.view.frame.size.width * 0.3))
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        if companyDataModel != nil {
            if selectedArray.count <= 0 {
                let emptyLabel: UILabel = UILabel() as UILabel
                emptyLabel.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
                emptyLabel.text = "Result not found"
                emptyLabel.textAlignment = .center
                emptyLabel.textColor = HelpingMethods.hexStringToUIColor(hex: AppConstants.whiteBackgroundColor)
                emptyLabel.backgroundColor = UIColor.black
                self.CollectionView.backgroundView = emptyLabel
                return 0
                
            }
            else{
                self.CollectionView.backgroundView = .none
                return selectedArray.count
                
            }
            
        }
        else{
            return 0
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CompanyInfoCell", for: indexPath) as! CompanyInfoCell
        
        cell.companyName.text = selectedArray[indexPath.row].companyName
        var pricePercent = selectedArray[indexPath.row].priceChange * 100
        cell.priceChangePercent.text = "\(HelpingMethods.formatPecentage(String(pricePercent))) %"
        //        cell.contentView.backgroundColor = UIColor.green
        //
        //
        if selectedArray[indexPath.row].type == AppConstants.shortType{
            cell.contentView.backgroundColor = HelpingMethods.hexStringToUIColor(hex: AppConstants.short)
        }
        else if selectedArray[indexPath.row].type == AppConstants.longType{
            cell.contentView.backgroundColor = HelpingMethods.hexStringToUIColor(hex: AppConstants.long)
            
        }
        else if selectedArray[indexPath.row].type == AppConstants.LongUnwindingType{
            cell.contentView.backgroundColor = HelpingMethods.hexStringToUIColor(hex: AppConstants.LongUnwindingColorCode)
            
        }
        else if selectedArray[indexPath.row].type == AppConstants.shortCoveringType{
            cell.contentView.backgroundColor = HelpingMethods.hexStringToUIColor(hex : AppConstants.shortCovering)
            
        }
        
        return cell
        
    }
    
    
    
    
    
    
    
    
}
