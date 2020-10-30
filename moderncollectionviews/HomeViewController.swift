//
//  HomeViewController.swift
//  moderncollectionviews
//
//  Created by Jazmine Paola Barroga on 10/28/20.
//  Copyright © 2020 jazminebarroga. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>! = nil
    
    let viewModel = ViewModel()
    
    var collectionView: UICollectionView! = nil
    
    var currentSnapshot: NSDiffableDataSourceSnapshot<Section, Item>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        
        /// Start configuring collection view
        configureHierarchy()
        configureDatasource()
        configureSupplementaryViews()
        
        // Load Now Watching Section
        performUpdateAdvanced()
    }
    
    func configureHierarchy() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    /// Compositional Layout Demo
    func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int,
                                 layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            
            let section: NSCollectionLayoutSection
            
            switch sectionKind {
            case .nowWatching:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                // if we have the space, adapt and go 2-up + peeking 3rd item
                let groupFractionalWidth = CGFloat(layoutEnvironment.container.effectiveContentSize.width > 500 ?
                                                    0.425 : 0.85)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupFractionalWidth),
                                                       heightDimension: .absolute(250))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                section = NSCollectionLayoutSection(group: group)
                
                /// Dictates vertical/horizontal scrolling. In this case, continuous means horizontal scrolling. By default, it's vertical scrolling
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 20
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
                
            case .recommendedShows:
                let configuration = UICollectionLayoutListConfiguration(appearance: .sidebarPlain)
                section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
                
            case .trending:
                
                /// Calculate item size
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                     heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

                
                /// Calculate group size
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(240))
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                                 subitems: [item])

                section = NSCollectionLayoutSection(group: group)
                
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)

            }
            
            
            // Configure Section headers
            let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .estimated(44))
            let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: titleSize,
                elementKind: "title-element-kind",
                alignment: .top)
            section.boundarySupplementaryItems = [titleSupplementary]
            return section
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        
        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: sectionProvider, configuration: config)
        return layout
    }
    
    // Diffable Data Sources Demo
    private func configureDatasource() {
        ///
    
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, item in
                guard let self = self, let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section") }
                switch section {
                case .nowWatching:
                    if case let .nowWatching(kdrama) = item {
                        return collectionView.dequeueConfiguredReusableCell (
                            using: self.makeNowWatchingKDramaCellRegistration(),
                            for: indexPath,
                            item: kdrama)
                    }
                case .recommendedShows:
                    if case let .recommendedShows(kdrama) = item {
                        return collectionView.dequeueConfiguredReusableCell (
                            using: self.makeDefaultListHeaderCellRegistration(),
                            for: indexPath,
                            item: kdrama)
                    } else if case let .kdramaDetail(kdramaDetail) = item {
                        return collectionView.dequeueConfiguredReusableCell (
                            using: self.makeDefaultListContentCellRegistration(),
                            for: indexPath,
                            item: kdramaDetail)
                        }
                case .trending:
                    if case let .trending(kdrama) = item {
                        return collectionView.dequeueConfiguredReusableCell (
                            using: self.makeNowWatchingKDramaCellRegistration(),
                            for: indexPath,
                            item: kdrama)
                    }
                }
                return nil
                
            }
        )
    }
    
    // Sample supplementary views
    private func configureSupplementaryViews() {
        
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration<SectionHeaderView>(elementKind: "Header") {
            (supplementaryView, string, indexPath) in
            if let snapshot = self.currentSnapshot {
                // Populate the view with our section's description.
                let kdramaSection = snapshot.sectionIdentifiers[indexPath.section]
                supplementaryView.label.text = kdramaSection.title
            }
        }
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(
                using: supplementaryRegistration, for: index)
        }
    }
    
    // Custom Cell Registration using Nibs
    private func makeNowWatchingKDramaCellRegistration() -> UICollectionView.CellRegistration<NowWatchingKDramaCell, KDrama> {
        return UICollectionView.CellRegistration<NowWatchingKDramaCell, KDrama>(cellNib: UINib(nibName: "NowWatchingKDramaCell", bundle: nil))  { cell, indexPath, kdrama in
            cell.bannerView.image = UIImage(named: kdrama.image!)!
            cell.titleLabel.text = kdrama.title
            cell.subtitleLabel.text = kdrama.subtitle
        }
    }
    
    // Default List Header Cell Registration
    private func makeDefaultListHeaderCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, KDrama> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, KDrama> { (cell, indexPath, kdrama) in
            /// Acts as a viewModel
            var content = cell.defaultContentConfiguration()
            content.text = kdrama.title
            cell.contentConfiguration = content
            
            cell.accessories = [.outlineDisclosure(options: .init(style: .header))]
        }
    }
    
    private func makeDefaultListContentCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, KDramaDetail> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, KDramaDetail> { (cell, indexPath, kdrama) in
            var content = cell.defaultContentConfiguration()
            content.text = kdrama.title
            content.secondaryText = kdrama.value
            cell.contentConfiguration = content
            cell.accessories = [.disclosureIndicator()]
        }
    }
    
    /// Diffable Data Sources 3 Step Process
    private func performUpdate() {
        /// 1. Create the snapshot
        currentSnapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        /// 2. Populate the snapshot
        currentSnapshot.appendSections(Section.allCases)
        currentSnapshot.appendItems(viewModel.nowWatching.map { .nowWatching($0) }, toSection: .nowWatching)
        currentSnapshot.appendItems(viewModel.recommendedKdramas.map { .recommendedShows($0) }, toSection: .recommendedShows)
        currentSnapshot.appendItems(viewModel.trendingKdramas.map { .trending($0) }, toSection: .trending)

        
        /// 3. Apply the snapshot
        dataSource.apply(currentSnapshot, animatingDifferences: true)
    }
    
    /// Advances in Diffable Data Sources (WWDC20)
    private func performUpdateAdvanced() {
        /// Set the snapshot for our sections
        let sections = Section.allCases
        currentSnapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        currentSnapshot.appendSections(sections)
        dataSource.apply(currentSnapshot, animatingDifferences: true)
        
        /// Apply snapshot for now watching section
        let nowWatchingItems: [Item] = viewModel.nowWatching.map { .nowWatching($0) }
        var nowWatchingSectionSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
        nowWatchingSectionSnapshot.append(nowWatchingItems)
        dataSource.apply(nowWatchingSectionSnapshot, to: .nowWatching, animatingDifferences: true)
        
        /// Apply snapshot for Top 5 section
        // Setup parent/child relations for expandable list views
        var recommendedSectionSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()

        for kdrama in viewModel.recommendedKdramas {
            let rootItem: Item = .recommendedShows(kdrama)
            recommendedSectionSnapshot.append([rootItem])
            let detailItems: [Item] = kdrama.detail!.map { .kdramaDetail($0) }
            recommendedSectionSnapshot.append(detailItems, to: rootItem)
        }
        
        /// Apply updates to each section
        dataSource.apply(nowWatchingSectionSnapshot, to: .nowWatching, animatingDifferences: true)
        dataSource.apply(recommendedSectionSnapshot, to: .recommendedShows, animatingDifferences: true)
    }
    
    private func performUpdateTrendingSection() {
        var trendingSectionSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
        trendingSectionSnapshot.append(viewModel.trendingKdramas.map { .trending($0) })
        
        dataSource.apply(trendingSectionSnapshot, to: .trending, animatingDifferences: true)
        

    }
    
}
    

extension HomeViewController {
    enum Section: Int, CaseIterable {
        case nowWatching
        case recommendedShows
        case trending
        
        var title: String {
            switch self {
            case .nowWatching: return "Now Watching"
            case .recommendedShows: return "Top 5"
            case .trending: return "Trending Worldwide"
            }
        }
    }
    
    enum Item: Hashable {
        case nowWatching(KDrama)
        case recommendedShows(KDrama)
        case trending(KDrama)
        case kdramaDetail(KDramaDetail)
    
//        func hash(into hasher: inout Hasher) {
//            switch self {
//            case .nowWatching(let kdrama):
//                return hasher.combine(kdrama.identifier)
//            case .recommendedShows(let kdrama):
//                return hasher.combine(kdrama.identifier)
//            case .trending(let kdrama):
//                return hasher.combine(kdrama.identifier)
//            case .kdramaDetail(let detail):
//                return hasher.combine(detail.identifier)
//            }
//          //  hasher.combine(identifier)
//        }
//
//        static func ==(lhs: Item, rhs: Item) -> Bool {
//            switch (lhs, rhs) {
//            case (.nowWatching(let kdrama1), .nowWatching(let kdrama2)):
//                return kdrama1.identifier == kdrama2.identifier
//            case (.recommendedShows(let kdrama1), .recommendedShows(let kdrama2)):
//                return kdrama1.identifier == kdrama2.identifier
//            case (.trending(let kdrama1), .trending(let kdrama2)):
//                return kdrama1.identifier == kdrama2.identifier
//            case (.kdramaDetail(let detail1), .kdramaDetail(let detail2)):
//                return detail1.identifier == detail2.identifier
//            default:
//                return false
//            }
//        }
    }
}


extension HomeViewController: ViewModelDelegate {
    func didFinishGeneratingTrendingKdramas() {
        performUpdateTrendingSection()
    //    performUpdate()
    }
}
