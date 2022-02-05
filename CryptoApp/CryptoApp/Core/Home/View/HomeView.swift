//
//  HomeView.swift
//  CryptoApp
//
//  Created by Майлс on 09.11.2021.
//

import SwiftUI

struct HomeView: View {
    
    ///Свойство среды, передает данные основной ViewModel.
    @EnvironmentObject private var vm: HomeViewModel
    ///Булевое свойство, в зависимости от которого проигрывается анимация показа листа в портфолио
    @State private var showPortfolio: Bool = false
    ///Показывает портфолио с валютой
    @State private var showPorfolioView: Bool = false
    @State private var showSettingdView: Bool = false
    @State private var selectedCoin: CoinModel? = nil
    @State private var showDetailView: Bool = false
    
    var body: some View {
        
        ZStack {
            //Задний фон, цвет меняется в зависимости от установленной темы.
            Color.colorsTheme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPorfolioView) {
                    PortfolioView().environmentObject(vm)
                }
            
            //Передний фон, с контентом.
            VStack {
                homeHeader
                HomeStatsView(showPortfolio: $showPortfolio)
                SearchBarView(searchtext: $vm.searchText)
                columnsTitles
                
                //Отображение листа монет, без имеющихся в портфеле
                if !showPortfolio {
                    allCoinsList
                        .transition(.move(edge: .leading))
                }
                //Отображение листа валюты, при переключении на портфель.
                if showPortfolio {
                    ZStack(alignment: .top) {
                        if vm.portfolioCoins.isEmpty && vm.searchText.isEmpty {
                            noCoinsView
                        } else {
                            portfolioCoinsList
                        }
                    }
                    .transition(.move(edge: .trailing))
                }
                Spacer(minLength: 0)
            }
            .sheet(isPresented: $showSettingdView) { SettingsView() }
        }
        .background(
            NavigationLink(
                destination: DetailLoadingView(coin: $selectedCoin),
                isActive: $showDetailView,
                label: { EmptyView() })
        )
    }
}

//MARK: - VIEWS
extension HomeView {
    //HEADER
    private var plusInfoButton: some View {
        CircleButtonView(iconName: showPortfolio ? "plus" : "info")
            .animation(.none)
            .background(CircleButtonAnimationView(animation: $showPortfolio))
            .onTapGesture {
                if showPortfolio {
                    showPorfolioView.toggle()
                } else {
                    showSettingdView.toggle()
                }
            }
    }
    ///Свойство, в котором хранится заголовок
    private var barTitle: some View {
        Text(showPortfolio ? "Portfolio" : "Live Prices")
            .foregroundColor(Color.colorsTheme.accent)
            .font(.headline)
            .fontWeight(.heavy)
            .animation(.none)
    }
    ///Своство, в котором храниться кнопка переключения с портфеля на общее View
    private var chevronButton: some View {
        CircleButtonView(iconName: "chevron.right")
            .rotationEffect(Angle.degrees(showPortfolio ? 180 : 0))
            .onTapGesture {
                withAnimation(.spring()) {
                    showPortfolio.toggle()
                }
            }
    }
    ///Свойство, в котором хранятся все заголовочные элементы View
    private var homeHeader: some View {
        HStack {
            plusInfoButton
            Spacer()
            barTitle
            Spacer()
            chevronButton
        }.padding(.horizontal)
    }
    
    //LIST OF COINS
    ///Свойство, в котором хранится заголовочные элементы листа в монетами.
    private var columnsTitles: some View {
        HStack {
            HStack(spacing: 4) {
                Text("Coins")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortingOption == .rank || vm.sortingOption == .reversedRank ? 1.0 : 0.0))
                    .rotationEffect(Angle(degrees: vm.sortingOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortingOption = vm.sortingOption == .rank ? .reversedRank : .rank
                }
            }
            
            Spacer()
            if showPortfolio {
                HStack(spacing: 4) {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity((vm.sortingOption == .holdings || vm.sortingOption == .reversedHoldings ? 1.0 : 0.0))
                        .rotationEffect(Angle(degrees: vm.sortingOption == .holdings ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation(.default) {
                        vm.sortingOption = vm.sortingOption == .holdings ? .reversedHoldings : .holdings
                    }
                }
            }
            
            HStack(spacing: 4) {
                Text("Price")
                    .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
                Image(systemName: "chevron.down")
                    .opacity((vm.sortingOption == .price || vm.sortingOption == .reversedPrice ? 1.0 : 0.0))
                    .rotationEffect(Angle(degrees: vm.sortingOption == .price ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortingOption = vm.sortingOption == .price ? .reversedPrice : .price
                }
            }
            
            Button(action: {
                withAnimation(. linear(duration: 2.0)) {
                    vm.reloadData()
                }
            }) {
                Image(systemName: "goforward")
            }
            .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0), anchor: .center)
        }
        .font(.caption)
        .foregroundColor(Color.colorsTheme.secondaryText)
        .padding()
    }
    ///Свойство храненения листа с валютой.
    private var allCoinsList: some View {
        List {
            ForEach(vm.allCoins) { coin in //Передаем через ViewModel что будем отображать.
                CoinRowView(showHoldingsColumn: false, coin: coin)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(coin: coin)
                    }
                    .listRowBackground(Color.colorsTheme.background)
            }
        }
        .listStyle(PlainListStyle())
    }
    ///Свойство храненения листа с монетами, отображаемое при переходе к портфелю с имеющимися монетами.
    private var portfolioCoinsList: some View {
        List {
            ForEach(vm.portfolioCoins) { coin in //Передаем для отображения данные из ViewModel
                CoinRowView(showHoldingsColumn: true, coin: coin)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(coin: coin)
                    }
                    .listRowBackground(Color.colorsTheme.background)
            }
        }
        .listStyle(PlainListStyle())
    }
    
    //VIEWS
    private var noCoinsView: some View {
        Text("You haven't added any coins to your portfolio yet. Click the + button to get started!")
            .font(.callout)
            .foregroundColor(Color.colorsTheme.accent)
            .fontWeight(.medium)
            .multilineTextAlignment(.center)
            .padding(50)
    }
}

//MARK: - METHODS
extension HomeView {
    private func segue(coin: CoinModel) {
        selectedCoin = coin
        showDetailView.toggle()
    }
}


//MARK: - PREVIEW
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .navigationBarHidden(true)
                .environmentObject(dev.homeVM)
        }
    }
}

//КРАТКАЯ ДОКУМЕНТАЦИЯ ДЕЙСТВИЙ
/*
 1. Настраиваем проект и создаем в расширении кастомные цвета (Extension -> Colors)
 2. Создаем HomeView, скрываем стандартный NavigationBar и создаем кастомный NavigationBar (Core -> View -> HomeView)
    2.1 Создаем шаблон кнопки и анимацию переключения (Core -> Components -> CircleButtonView, CircleButtonAnimationView)
 3. Создаем Модель данных основываясь на JSON данных с API (Model -> CoinModel)
 4. Создаем строки для отображения монет (CoinRowView)
 5. Создаем в расширении к Preview Provider шаблон для отображения в Preview
    5.1 Создаем в расширении к типу Double конвертации чисел с плавающей точкой, которые позже используются в CoinRowView.
 6. Создаем HomeViewModel, которая будет содержать в себе, то что будет отображаться в HomeView
 7. Создаем CoinDataServices, который является классом с методами получения данных о валюте с сервера
    7.1 Подписываем в HomeViewModel свойство allCoins на все изменения которые происходят в свойстве allCoins в CoinDataServices
 8. Создаем универсальный шаблон работы с данными с сервера NetworkingManager и используем его в CoinDataServices
 9. Создаем CoinImageService который является классом с методами получения данных об изображении валют с сервера
    9.1 Создаем CoinImageView который ответственен, за то, как будет выглядеть изображение валюты.
    9.2 Создаем CoinImageViewModel, который ответственен за то, что будет отображать изображение, содержит в себе свойство изображения с сервера.
 10. Создаем шаблон поисковой строки SearchBarView, расширение к UIApplication.
 11. Добавление логики фильтрации элементов в HomeViewModel.
 12. Создан подзаголовочный файл с рыночными - HomeStatsView, его модель данных StatisticModel и компонент отображающий как все должно выглядеть StatisticView.
 13. Настроили рыночные данные, получив к ним доступ с сервера, создали форматирующее расширение к Double.
 14. Создали View где добавляется валюта к портфолио.
 15. Создана логика добавления валюты в портфель в PortfolioDataService  и реализована в HomeViewModel.
 16. Созданы методы обновления данных о валюте с API, добавлен класс HaptiManager, добаляющий вибрации при обновлении данных.
 17. Создана логика сортировки валюты, добавлены кнопки с анимацией сортировки.
 18. Создано View для отображения деталей, так же создана кастомная навигация к каждой валюте.
 19. Создана модель и модель представления описания валюты, API взят с сайта coingecko.
 20. Добавлена логика отображения данных о валюте с помощью Combine при нажатии на валюту.
 21. Создан график изменения стоймости валюты (надо разобраться с проблемой DispatchQueue).
 22. Создан экран с информацией и настройками.
 23. Создан кастомный экран загрузки, добавлены новый цветовые схемы и иконки.
 24. Оптимизация кода.
 25. Небольшие изменения в цветовых схемах.
 */
