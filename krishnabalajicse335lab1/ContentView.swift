import SwiftUI

struct ContentView: View {
    @State var height: String = ""
    @State var weight: String = ""
    @State var waistcf: String = ""
    @State var bmi: String = "Enter your height, weight and waistcf"
    @State var risklevel: String = "Risk level shown here"
    @State var bmiIndicator: String = "BMI shown here"
    @State var gender: String = "Male"
    @State var calculatedBmi: Double = 0.0
    @State private var showalert = false
    @State private var alertMessage = ""
    @State var obesityclass: String = "N/A"
    
    var body: some View {
        VStack{
            Text("BMI & Disease Risk Calculator")
                .font(.largeTitle)
                .padding()
            Spacer()
            
            Picker("Gender", selection: $gender) {
                Text("Male").tag("Male")
                Text("Female").tag("Female")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            
            HStack {
                Text("Height (inches only): ")
                Spacer()
                TextField("Enter your height: ", text: $height)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            
            HStack{
                Text("Weight (pounds only): ")
                Spacer()
                TextField("Enter your weight: ", text: $weight)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            
            HStack{
                Text("Waist Circumference (inches only) : ")
                Spacer()
                TextField("Enter your waist circumference: ", text: $waistcf)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            
            Button (action: {
                Bmicalculation()
                showalert = true
            }) {
                Text("Determine Risk")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .alert("Summary of Data", isPresented: $showalert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
            
            
            VStack {
                Text("BMI Value: \(bmi) (\(bmiIndicator))")
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(10)
        
                Text("Disease Risk Level: \(risklevel)")
                    .padding()
                    .background(displayColor())
                    .cornerRadius(10)
                    .foregroundColor(.black)
                
                Text("Obesity Class: \(obesityclass)")
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .foregroundColor(.black)
            }
            Spacer()
        }
        .padding()
    }
    
    func Bmicalculation() {
        
        print("Height: \(height)")
        print("Weight: \(weight)")
        print("Waist Circumference: \(waistcf)")
        if let weight = Double(weight), let height = Double(height) {
            calculatedBmi = (weight / (height*height)) * 703
            bmi = String(format: "%.1f", calculatedBmi)
            
            switch calculatedBmi {
            case ..<18.5:
                bmiIndicator = "Underweight"
                obesityclass = "N/A"
            case 18.5..<25:
                bmiIndicator = "Normal"
                obesityclass = "N/A"
            case 25..<30:
                bmiIndicator = "Overweight"
                obesityclass = "N/A"
            case 30..<35:
                bmiIndicator = "Obesity"
                obesityclass = "I"
            case 35..<40:
                bmiIndicator = "Obesity"
                obesityclass = "II"
            case 40...:
                bmiIndicator = "Extreme Obesity"
                obesityclass = "III"
            default:
                bmiIndicator = "Invalid BMI"
            }
            if let waistcf = Double(waistcf) {
                if (gender == "Male" && waistcf <= 40) || (gender == "Female" && waistcf <= 35) {
                    if (bmiIndicator == "Overweight") {
                        risklevel = "Increased"
                    }
                    else if (bmiIndicator == "Obesity" && obesityclass == "I") {
                        risklevel = "High"
                    }
                    else if (bmiIndicator == "Obesity" && obesityclass == "II") {
                        risklevel = "Very High"
                    }
                    else if (bmiIndicator == "Extreme Obesity") {
                        risklevel = "Extremely High"
                    }
                    else {
                        risklevel = "No risk"
                    }
                }
                else if (gender == "Male" && waistcf > 40) || (gender == "Female" && waistcf > 35) {
                    if (bmiIndicator == "Overweight") {
                        risklevel = "High"
                    }
                    else if (bmiIndicator == "Obesity") {
                        risklevel = "Very High"
                    }
                    else if (bmiIndicator == "Extreme Obesity") {
                        risklevel = "Extremely High"
                    }
                    else {
                        risklevel = "No risk"
                    }
                }
            }
            alertMessage = "BMI Value: \(bmi) (\(bmiIndicator))\n Disease Risk Level: \(risklevel)\n Obesity Class: \(obesityclass)"
            
        }
        else {
            bmiIndicator = "Invalid input"
            risklevel = "Cannot be determined"
            alertMessage = "Invalid input. Please check your entries."
            obesityclass = "Does not exist"
        }
    }
    
    func displayColor() -> Color {
        switch risklevel {
        case "Increased":
            return Color.yellow
        case "High":
            return Color.purple
        case "Very High":
            return Color.orange
        case "Extremely High":
            return Color.red
        default:
            return Color.white
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
