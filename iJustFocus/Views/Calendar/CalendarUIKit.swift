//
//  CalendarUIKit.swift
//  iJustFocus
//
//  Created by Huy Ong on 4/3/23.
//

import SwiftUI

struct CalendarContainer: UIViewControllerRepresentable {
  func makeUIViewController(context: Context) -> some UIViewController {
    let vc = CalendarViewController()
    return vc
  }
  
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    
  }
}

class DateCell: UICollectionViewCell {
  
  var date: Date? {
    didSet {
      updateLabel()
    }
  }
  
  private let dateLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 16)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupViews() {
    addSubview(dateLabel)
    NSLayoutConstraint.activate([
      dateLabel.topAnchor.constraint(equalTo: topAnchor),
      dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
      dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
      dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
    ])
  }
  
  private func updateLabel() {
    if let date = date {
      let day = Calendar.current.component(.day, from: date)
      dateLabel.text = "\(day)"
      if Calendar.current.isDateInToday(date) {
        dateLabel.font = .boldSystemFont(ofSize: 16)
      }
    } else {
      dateLabel.text = ""
    }
  }
}


class CalendarViewController: UIViewController {
  
  enum CalendarViewMode {
    case month, week
  }
  
  private var calendarViewMode: CalendarViewMode = .month
  
  private lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.backgroundColor = .systemBackground
    return collectionView
  }()
  
  private let segmentedControl: UISegmentedControl = {
    let items = ["Month", "Week"]
    let segmentedControl = UISegmentedControl(items: items)
    segmentedControl.selectedSegmentIndex = 0
    segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
    return segmentedControl
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    collectionView.register(DateCell.self, forCellWithReuseIdentifier: "DateCell")
    collectionView.dataSource = self
    collectionView.delegate = self
  }
  
  
  private func setupViews() {
    view.addSubview(collectionView)
    navigationItem.titleView = segmentedControl
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
    ])
  }
  
  @objc private func segmentedControlChanged(_ sender: UISegmentedControl) {
    calendarViewMode = sender.selectedSegmentIndex == 0 ? .month : .week
    collectionView.setCollectionViewLayout(createLayout(), animated: true)
  }
  
  private func createLayout() -> UICollectionViewLayout {
    switch calendarViewMode {
    case .month:
      return createMonthlyLayout()
    case .week:
      return createWeeklyLayout()
    }
  }
  
  private func createMonthlyLayout() -> UICollectionViewLayout {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0 / 6))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 7)
    
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = 2
    section.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
    
    return UICollectionViewCompositionalLayout(section: section)
  }
  
  private func createWeeklyLayout() -> UICollectionViewLayout {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 7)
    
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = 2
    section.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
    
    return UICollectionViewCompositionalLayout(section: section)
  }
  
  private let calendar = Calendar.current
  private var currentDate = Date()
  
  private func startDateOfMonth(for date: Date) -> Date {
    let components = calendar.dateComponents([.year, .month], from: date)
    return calendar.date(from: components)!
  }
  
  private func endDateOfMonth(for date: Date) -> Date {
    let nextMonth = calendar.date(byAdding: .month, value: 1, to: date)!
    return calendar.date(byAdding: .day, value: -1, to: nextMonth)!
  }

  
}

extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch calendarViewMode {
    case .month:
      let firstDayOfMonth = startDateOfMonth(for: currentDate)
      let firstDayOfWeek = calendar.dateComponents([.weekday], from: firstDayOfMonth).weekday! - calendar.firstWeekday
      let numberOfDaysInMonth = calendar.range(of: .day, in: .month, for: currentDate)!.count
      return numberOfDaysInMonth + firstDayOfWeek
    case .week:
      return 7
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCell
    
    switch calendarViewMode {
    case .month:
      let firstDayOfMonth = startDateOfMonth(for: currentDate)
      let firstDayOfWeek = calendar.dateComponents([.weekday], from: firstDayOfMonth).weekday! - calendar.firstWeekday
      let dayOffset = indexPath.row - firstDayOfWeek
      
      if dayOffset >= 0 {
        let date = calendar.date(byAdding: .day, value: dayOffset, to: firstDayOfMonth)!
        cell.date = date
      } else {
        cell.date = nil
      }
      
      
    case .week:
      let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate))!
      let date = calendar.date(byAdding: .day, value: indexPath.row, to: startOfWeek)!
      cell.date = date
    }
    
    return cell
  }
  
}

