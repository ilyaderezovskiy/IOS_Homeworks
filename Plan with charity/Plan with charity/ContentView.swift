//
//  ContentView.swift
//  Plan with charity
//
//  Created by Ilya Derezovskiy on 13.02.2022.
//

import SwiftUI
import CoreData
import EventKit

class TaskViewModel: ObservableObject {

    @Published var tasks: [Task] = [
        Task(name: "Подготовить презентацию", deadline: getSamleDate(offset: -1), annotation: "14 done", cost: 100, notification: false, isDone: true),
        
        Task(name: "Подготовить презентацию", deadline: getSamleDate(offset: -1), annotation: "14", cost: 100, notification: false, isDone: false),
        
        Task(name: "Подготовить презентацию", deadline: getSamleDate(offset: 1), annotation: "16", cost: 100, notification: false, isDone: false),
        
        Task(name: "Подготовить презентацию", deadline: getSamleDate(offset: 1), annotation: "16", cost: 100, notification: false, isDone: false),
    ]
    
    func shuffle() {
        tasks = tasks.sorted(by: {first, second in
            return first.cost > second.cost
        })
    }
}

struct ContentView: View {
    @State var selected = 0
    @ObservedObject var viewModel = TaskViewModel()
    @State var isPresented = false
    @State var showingDetail = false
    @State var sum : Int = 0
    @State private var selectedOrganization = ""
    var viewModelCharityOrganizations = CharityOrganizationViewModel()
    let paymentHandler = PaymentHandler()
    @ObservedObject var notificationManager = LocalNotificationManager()
    @State var showFootnote = false
    
    init() {
        viewModel.tasks = viewModel.tasks.sorted { ($0.deadline)!.compare($1.deadline!) == .orderedAscending}
    }
    
    var body: some View {
        VStack (spacing: 6) {
            TopBar(selected: $selected, viewModel: viewModel)
            GeometryReader { _ in
                VStack {
                    ScrollView(.vertical) {
                        VStack(spacing: 15) {
                            let columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 1)
                            LazyVGrid(columns: columns, spacing: 25) {
                                if self.selected == 0 {
                                    ForEach(viewModel.tasks.indices) { index in
                                        if !viewModel.tasks[index].isDeleted && !viewModel.tasks[index].isDone && viewModel.tasks[index].deadline! >= NSDate() as Date {
                                            CardView(viewModel: viewModel, index: index)
                                        }
                                    }
                                }
                                else if self.selected == 1 {
                                    ForEach(viewModel.tasks.indices) { index in
                                        if !viewModel.tasks[index].isDeleted && (viewModel.tasks[index].isDone || viewModel.tasks[index].deadline! < NSDate() as Date) {
                                            CardView(viewModel: viewModel, index: index)
                                        }
                                    }
                                }
                                else if self.selected == 2 {
                                    VStack(spacing: 20) {
                                        HStack {
                                            Text("Накопленная сумма:").font(.system(size: 25)).fontWeight(.semibold).foregroundColor(Color("Blue"))

                                            Spacer()

                                            Text("\(sum)").font(.system(size: 20)).fontWeight(.light)
                                            .onAppear {
                                                self.checkTasks()
                                            }
                                        }
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            sum = 0
                                        }) {
                                            Text("Сбросить сумму").font(.system(size: 16)).fontWeight(.semibold).foregroundColor(Color("Blue"))
                                        }
                                        
                                        HStack {
                                            Text("Выбрать организацию:").font(.system(size: 25)).fontWeight(.semibold).foregroundColor(Color("Blue"))
                                            Spacer(minLength:  8)
                                        }.padding(.top)

                                        Picker("Организация", selection: $selectedOrganization) {
                                            ForEach(viewModelCharityOrganizations.organizations, id: \.name) {
                                                Text($0.name)
                                            }
                                        }.padding(.top, -15)

                                        Button(action: {
                                            isPresented = true
                                            self.showingDetail.toggle()
                                        }) {
                                            Text("Узнать о доступных организациях").font(.system(size: 16)).fontWeight(.semibold).foregroundColor(Color("Blue"))
                                        }.sheet(isPresented: $isPresented) {
                                            ShowOrganizations()
                                        }
                                        
                                        Button(action: {
                                            if (sum > 0) {
                                                self.paymentHandler.totalSum = Double(sum)
                                                self.paymentHandler.startPayment() { (success) in
                                                    if success {
                                                        print("Success")
                                                        sum = 0
                                                    } else {
                                                        print("Failed")
                                                    }
                                                }
                                            }
                                        }) {
                                            Text("Оплатить с помощью  APPLE PAY")
                                            .font(Font.custom("HelveticaNeue-Bold", size: 17))
                                            .foregroundColor(.black)
                                            .padding()
                                            .overlay(RoundedRectangle(cornerRadius: 19).stroke(Color.black, lineWidth:1))
                                        }.padding(.top, 35)
                                    }.padding()
                                
                                }
                            }
                            .padding(.top, 30)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .padding(.top, 15)
                    .padding(.horizontal, 20)
                }
            }
        }.edgesIgnoringSafeArea(.top)
}
    
    func checkTasks() {
        for index in 0..<self.viewModel.tasks.count {
            if !viewModel.tasks[index].isDeleted && !viewModel.tasks[index].isDone && viewModel.tasks[index].deadline! < NSDate() as Date {
                self.sum += viewModel.tasks[index].cost
                viewModel.tasks[index].cost = 0
            }
        }
    }
}

struct CardView : View {
    @ObservedObject var viewModel: TaskViewModel
    @ObservedObject var task = Task()
    @State var showingDetail = false
    @State var isPresented = false
    var index: Int
    
    var body: some View {
    VStack {
        HStack {
            Text(self.viewModel.tasks[index].name)
                .font(.title3)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(4)
                .opacity(0.8)
            
            Spacer(minLength: 0)
            
            Button {
                viewModel.tasks[index].isDone = !viewModel.tasks[index].isDone
                viewModel.shuffle()
            } label: {
                Image(systemName: "checkmark")
                    .font(.system(size: 15, weight: .bold))
                    .padding(8)
                    .foregroundColor(self.viewModel.tasks[index].isDone ? .white : Color("DarkGreen"))
                    .background(self.viewModel.tasks[index].isDone ? Color("DarkGreen") : Color.white)
                    .clipShape(Circle())
            }
        }
        .padding(.top, 15)
        
        Text(self.viewModel.tasks[index].notification ? "Напоминание включено" : "Напоминание выключено")
            .font(.subheadline)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
        
        Spacer()
        
        Text("Описание: " + self.viewModel.tasks[index].annotation)
            .font(.subheadline)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
        
        HStack {
            
            Text(self.viewModel.tasks[index].deadline!, style: .date)
                .foregroundColor(.black)
                .opacity(0.8)
            
            Spacer(minLength: 0)
            
            Button(action: {
                isPresented = true
                self.showingDetail.toggle()
            }) {
                Image(systemName: "pencil")
                    .font(.system(size: 15, weight: .bold))
                    .padding(8)
                    .foregroundColor(.white)
                    .background(Color.black)
                    .clipShape(Circle())
            }.sheet(isPresented: $isPresented) {
                UpdateTask(task: self.viewModel.tasks[index], newTask: Task(name: self.viewModel.tasks[index].name, deadline: self.viewModel.tasks[index].deadline, annotation: self.viewModel.tasks[index].annotation, cost: self.viewModel.tasks[index].cost, notification: self.viewModel.tasks[index].notification, isDone: self.viewModel.tasks[index].isDone), cost: String(self.viewModel.tasks[index].cost), viewModel: viewModel,
                    isPresented: $isPresented)
            }
        }
        .padding(.top, 15)
    }
    .padding()
    .background(self.viewModel.tasks[index].deadline! > getSamleDate(offset: 0) - 1 || self.viewModel.tasks[index].isDone ? Color("Green") : Color("Red"))
    .cornerRadius(18)
    }
}

struct CardViewOrganization : View {
    var viewModel = CharityOrganizationViewModel()
    var index: Int
    @Environment(\.openURL) var openURL
    
    var body: some View {
    ZStack {
        Image(self.viewModel.organizations[index].imgName)
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
            .opacity(0.5)
        
        VStack {
            HStack {
                Text(self.viewModel.organizations[index].name)
                    .font(.title)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(4)
                
                Button(action: {
                    openURL(self.viewModel.organizations[index].url)
                }) {
                    Image(systemName: "info.circle")
                        .font(.system(size: 27, weight: .light))
                        .padding(8)
                        .foregroundColor(.black)
                }.padding(.horizontal)
            }
                
            Spacer()
            
            Text(self.viewModel.organizations[index].annotation)
                .font(.callout)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(4)
                .padding(.top, 75)
                .padding(.bottom, 9)
        }
        .padding(.top, 15)
        .padding(.leading)
    }
    .padding(0)
    .cornerRadius(18)
    }
}

class Host: UIHostingController<ContentView> {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return.lightContent
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}

struct TopBar : View {
    
    @Binding var selected : Int
    @ObservedObject var task = Task()
    @State var showingDetail = false
    @ObservedObject var viewModel: TaskViewModel
    @State var isPresented = false
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Задачи").font(.system(size: 30)).fontWeight(.semibold).foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    //self.viewModel.tasks.append(Task())
                    isPresented = true
                    self.showingDetail.toggle()
                    self.selected = 1
                }) {
                    Image(systemName: "plus").resizable()
                        .frame(width: 30, height: 30, alignment: .topLeading)
                        .padding(8)
                        .background(Color.white)
                        .foregroundColor(Color("Blue"))
                        .clipShape(Circle())
                }.sheet(isPresented: $isPresented) {
                    AddTask(task: Task(), viewModel: viewModel, isPresented: $isPresented)
                }
            }
            
            HStack {
                Button(action: {
                    self.selected = 0
                    checkTasks()
                }) {
                    Text("Предстоящие").fontWeight(.semibold).foregroundColor(self.selected == 0 ? .white : Color.white.opacity(0.5))
                }
                
                Spacer(minLength:  8)
                
                Button(action: {
                    self.selected = 1
                    checkTasks()
                }) {
                    Text("Выполненные").fontWeight(.semibold).foregroundColor(self.selected == 1 ? .white : Color.white.opacity(0.5))
                }
                
                Spacer(minLength:  8)
                
                Button(action: {
                    let variable = ContentView()
                    variable.checkTasks()
                    self.selected = 2
                    checkTasks()
                }) {
                    Image(systemName: "person").resizable().frame(width: 30, height: 30, alignment: .center).foregroundColor(self.selected == 2 ? .white : Color.white.opacity(0.5))
                        
                }
            }.padding(.top)
        }.padding()
        .padding(.top, UIApplication.shared.windows.last?.safeAreaInsets.top ?? 0 + 40)
        .background(Color("Blue"))
    }
    
    func checkTasks() {
        for index in 0..<self.viewModel.tasks.count {
            if (self.viewModel.tasks[index].name == "") {
                self.viewModel.tasks.remove(at: index)
            }
        }
    }
}

struct ShowOrganizations : View {
    var viewModel = CharityOrganizationViewModel()
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                ForEach(viewModel.organizations.indices) { index in
                    CardViewOrganization(viewModel: viewModel, index: index)
                    Spacer(minLength: 40)
                }
            }.padding(.all)
        }.padding(.top, UIApplication.shared.windows.last?.safeAreaInsets.top  ?? 0)
    }
}


struct AddTask : View {
    @ObservedObject var task: Task
    @ObservedObject var viewModel: TaskViewModel
    @State private var selectedDate: Bool = false
    
    @State var showDatePicker: Bool = false
    @State var showingDetail = false
    @Binding var isPresented: Bool
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }
    
    var currency: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        return formatter
    }
    
    var body: some View {
        ScrollView(.vertical) {
            Button(action: {
                viewModel.tasks.append(task)
                isPresented = false
                
            }, label: {
                Text("Добавить".uppercased())
                    .bold()
            })
            .frame(width: 94, height: 15, alignment: .leading)
            .padding(12)
            .background(Color("Green"))
            .foregroundColor(Color("DarkGreen"))
            .clipShape(Rectangle())
            .cornerRadius(18)
            .padding(.top, 0)
            
        VStack(alignment: .leading, spacing: 30) {
            Spacer()
                TextField("Название задачи", text: $task.name).font(.system(size: 28))
                
                Text("Выполнить к").font(.system(size: 18)).fontWeight(.semibold).foregroundColor(.gray).multilineTextAlignment(.trailing)
                
                ZStack(alignment: .leading) {
                    HStack {
                        Button(action: {
                            hideKeyboard()
                            showDatePicker.toggle()
                            selectedDate = true
                        }, label: {
                            Text(task.deadline != nil ? dateFormatter.string(from: task.deadline!) : "Выбрать дату").font(.system(size: 17)).fontWeight(.light)
                        })
                    }
                    
                    if showDatePicker {
                        DatePickerWithButtons(showDatePicker: $showDatePicker, savedDate: $task.deadline, selectedDate: task.deadline ?? Date())
                            .animation(.linear)
                            .transition(.opacity)
                    }
                }
                
                Text("Напоминание").font(.system(size: 18)).fontWeight(.semibold).foregroundColor(.gray).multilineTextAlignment(.trailing)
                
                Text("Стоимость").font(.system(size: 18)).fontWeight(.semibold).foregroundColor(.gray).multilineTextAlignment(.trailing)
                
                TextField("Введите стоимость задачи",value : $task.cost, formatter: currency).keyboardType(.numberPad)
                
                Text("Описание").font(.system(size: 18)).fontWeight(.semibold).foregroundColor(.gray).multilineTextAlignment(.trailing)
                
                TextField("Краткое описание задачи", text: $task.annotation).font(.system(size: 15))
        }
    }.padding()
    .padding(.top, UIApplication.shared.windows.last?.safeAreaInsets.top ?? 0 + 40)
        
    Spacer(minLength:  8)
    }
}

struct UpdateTask : View {
    @ObservedObject var task: Task
    @ObservedObject var newTask: Task
    @State private var name: String = ""
    @State private var deadline: Date? = nil
    @State private var notification: Bool = false
    @State private var annotation: String = ""
    @State var cost: String
    @State private var isDone: Bool = false
    @ObservedObject var viewModel: TaskViewModel
    @Binding var isPresented: Bool
    
    @State private var selectedDate: Bool = false
    @State var showDatePicker: Bool = false
    @State var showingDetail = false
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }
    
    var currency: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        return formatter
    }
    
    var body: some View {
        ScrollView(.vertical) {
            Button(action: {
                task.name = newTask.name
                task.deadline = newTask.deadline == nil ? Date() : newTask.deadline
                task.notification = newTask.notification
                task.annotation = newTask.annotation
                task.cost = Int(cost)!
                isPresented = false
                viewModel.shuffle()
                
            }, label: {
                Text("Сохранить".uppercased())
                    .bold()
            })
            .frame(width: 108, height: 15, alignment: .leading)
            .padding(12)
            .background(Color("Green"))
            .foregroundColor(Color("DarkGreen"))
            .clipShape(Rectangle())
            .cornerRadius(18)
            .padding(.top, 0)
        
        VStack(alignment: .leading, spacing: 30) {
            Spacer()
            TextField(task.name, text: $newTask.name).font(.system(size: 28))
            
            Text("Выполнить к").font(.system(size: 18)).fontWeight(.semibold).foregroundColor(.gray).multilineTextAlignment(.trailing)
            
            Text(task.deadline != Date() ? dateFormatter.string(from: newTask.deadline!) : "!")
            
            ZStack(alignment: .leading) {
                HStack {
                    Button(action: {
                        hideKeyboard()
                        showDatePicker.toggle()
                        selectedDate = true
                    }, label: {
                        Text(deadline != nil ? dateFormatter.string(from: newTask.deadline!) : "Изменить дату").font(.system(size: 17)).fontWeight(.light)
                    })
                }

                if showDatePicker {
                    DatePickerWithButtons(showDatePicker: $showDatePicker, savedDate: $newTask.deadline, selectedDate: newTask.deadline ?? Date())
                            .animation(.linear)
                            .transition(.opacity)
                }
            }
        
            Text("Напоминание").font(.system(size: 18)).fontWeight(.semibold).foregroundColor(.gray).multilineTextAlignment(.trailing)
        
            Text("Стоимость").font(.system(size: 18)).fontWeight(.semibold).foregroundColor(.gray).multilineTextAlignment(.trailing)
        
            TextField("\(task.cost) руб.", text : $cost).keyboardType(.numberPad)
            
            Text("Описание").font(.system(size: 18)).fontWeight(.semibold).foregroundColor(.gray).multilineTextAlignment(.trailing)
        
            TextField(task.annotation, text: $newTask.annotation).font(.system(size: 15))
        }
        Button(action: {
            task.isDeleted = true
            isPresented = false
        }, label: {
            Text("Удалить".uppercased())
                .bold()
        })
        .frame(width: 82, height: 15, alignment: .leading)
        .padding(12)
        .background(Color("Red"))
        .foregroundColor(Color.white)
        .clipShape(Rectangle())
        .cornerRadius(18)
        .padding(.top, 50)
    }.padding()
    .padding(.top, UIApplication.shared.windows.last?.safeAreaInsets.top ?? 0 + 40)
    Spacer(minLength:  8)
    }
}

struct DatePickerWithButtons: View {
    
    @Binding var showDatePicker: Bool
    @Binding var savedDate: Date?
    @State var selectedDate: Date = Date()
    
    var body: some View {

        ZStack {
            
            VStack {
                DatePicker("ru" , selection: $selectedDate)
                    .datePickerStyle(GraphicalDatePickerStyle())
                
                Divider()
                HStack {
                    
                    Button(action: {
                        showDatePicker = false
                    }, label: {
                        Text("Закрыть")
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        savedDate = selectedDate
                        showDatePicker = false
                    }, label: {
                        Text("Сохранить".uppercased())
                            .bold()
                    })
                }
                .padding(.horizontal)
            }
            .padding()
            .background(
                Color("LightBlue")
                    .cornerRadius(30)
            )
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
