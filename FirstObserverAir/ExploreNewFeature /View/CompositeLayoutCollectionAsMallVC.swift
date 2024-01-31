//
//  CompositeLayoutCollectionAsMallVC.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 27.01.24.
//


//
//  DetailsView.swift
//  instaPocket
//
//  Created by Ислам Батыргереев on 16.01.2024.
//

//import UIKit
//
//protocol DetailsViewProtocol: AnyObject{
//
//}
//
//class DetailsView: UIViewController {
//
//    var presenter: DetailsViewPresenterProtocol!
//    var photoView: PhotoView!
//
//    private var menuViewHeight = UIApplication.topSafeArea + 50
//
//    lazy var topMenuView: UIView = {
//        $0.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: menuViewHeight)
//        $0.backgroundColor = .appMain
//        return $0
//    }(UIView())
//
//    lazy var backAction = UIAction { [weak self] _ in
//        self?.navigationController?.popViewController(animated: true)
//    }
//
//    lazy var menuAction = UIAction { [weak self] _ in
//        print("menu open")
//    }
//
//    lazy var navigationHeader: NavigationHeader = {
//        NavigationHeader(backAction: backAction, menuAction: menuAction, date: presenter.item.date)
//    }()
//
//    lazy var collectionView: UICollectionView = {
//        $0.backgroundColor = .none
//        $0.contentInset = UIEdgeInsets(top: 80, left: 0, bottom: 100, right: 0)
//        $0.dataSource = self
//        $0.delegate = self
//        $0.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
//        $0.register(TagCollectionCell.self, forCellWithReuseIdentifier: TagCollectionCell.reuseId)
//        $0.register(DetailsPhotoCell.self, forCellWithReuseIdentifier: DetailsPhotoCell.reuseId)
//        $0.register(DetailsDescriptionCell.self, forCellWithReuseIdentifier: DetailsDescriptionCell.reuseId)
//        $0.register(DetailsAddCommentCell.self, forCellWithReuseIdentifier: DetailsAddCommentCell.reuseId)
//        $0.register(DetailsMapCell.self, forCellWithReuseIdentifier: DetailsMapCell.reuseId)
//
//        return $0
//    }(UICollectionView(frame: view.bounds, collectionViewLayout: getCompositionLayout()))
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .appMain
//        view.addSubview(collectionView)
//        view.addSubview(topMenuView)
//        setupPageHeader()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        navigationController?.navigationBar.prefersLargeTitles = false
//        navigationItem.setHidesBackButton(true, animated: true)
//        navigationController?.navigationBar.isHidden = true
//
//        NotificationCenter.default.post(name: .hideTabBar, object: nil, userInfo: ["isHide": true])
//    }
//
//    private func setupPageHeader() {
//        let headerView = navigationHeader.getNavigationHeader(type: .back)
//        headerView.frame.origin.y = UIApplication.topSafeArea
//        view.addSubview(headerView)
//
//    }
//}
//
//extension DetailsView{
//    private func getCompositionLayout() -> UICollectionViewCompositionalLayout {
//        UICollectionViewCompositionalLayout{ [weak self] section, _ in
//
//            switch section {
//            case 0:
//                return self?.createPhotoSection()
//            case 1:
//                return self?.createTagSection()
//            case 2,3:
//                return self?.createDescriptionSection()
//            case 4:
//                return self?.createCommentFieldSection()
//            case 5:
//                return self?.createMapSection()
//            default:
//                return self?.createPhotoSection()
//            }
//        }
//    }
//
//    private func createPhotoSection() -> NSCollectionLayoutSection {
//        //item (size)
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
//                                              heightDimension: .fractionalHeight(1))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 30)
//
//        //group (size) + item
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8),
//                                               heightDimension: .fractionalHeight(0.7))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//
//        let section = NSCollectionLayoutSection(group: group)
//        section.orthogonalScrollingBehavior = .groupPagingCentered
//        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 30, bottom: 30, trailing: 30)
//        return section
//        //section + group
//    }
//    private func createTagSection() -> NSCollectionLayoutSection {
//        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(110), heightDimension: .estimated(10))
//
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
//                                                       subitems: [.init(layoutSize: groupSize)])
//        group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(10), top: nil, trailing: .fixed(0), bottom: nil)
//
//        let section = NSCollectionLayoutSection(group: group)
//        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 30, bottom: 20, trailing: 30)
//        section.orthogonalScrollingBehavior = .continuous
//        return section
//    }
//    private func createDescriptionSection() -> NSCollectionLayoutSection {
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
//
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
//                                                       subitems: [.init(layoutSize: groupSize)])
//
//        group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: nil, trailing: nil, bottom: .fixed(10))
//
//        let section = NSCollectionLayoutSection(group: group)
//        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 30, bottom: 0, trailing: 30)
//
//        return section
//    }
//    private func createCommentFieldSection() -> NSCollectionLayoutSection{
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
//                                              heightDimension: .fractionalHeight(1))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//
//        let section = NSCollectionLayoutSection(group: group)
//        section.contentInsets = NSDirectionalEdgeInsets(top: 30, leading: 30, bottom: 60, trailing: 30)
//
//        return section
//    }
//    private func createMapSection() -> NSCollectionLayoutSection{
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
//                                              heightDimension: .fractionalHeight(1))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(160))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//
//        let section = NSCollectionLayoutSection(group: group)
//        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30)
//
//        return section
//    }
//}
//
//extension DetailsView: UICollectionViewDataSource{
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        6
//    }
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        switch section {
//        case 0:
//            return presenter.item.photos.count
//        case 1:
//            return presenter.item.tags?.count ?? 0
//        case 3:
//            return presenter.item.comments?.count ?? 0
//        default:
//            return 1
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let item = presenter.item
//
//        switch indexPath.section {
//        case 0:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailsPhotoCell.reuseId, for: indexPath) as! DetailsPhotoCell
//
//            cell.configureCell(image: item.photos[indexPath.item])
//
//            return cell
//        case 1:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionCell.reuseId, for: indexPath) as! TagCollectionCell
//            cell.cellConfigure(tagText: item.tags?[indexPath.item] ?? "")
//            return cell
//        case 2,3:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailsDescriptionCell.reuseId, for: indexPath) as! DetailsDescriptionCell
//
//            if indexPath.section == 2 {
//                cell.configureCell(date: nil, text: item.description ?? "")
//            } else {
//                let comment = item.comments?[indexPath.row]
//                cell.configureCell(date: comment?.date, text: comment?.comment ?? "")
//            }
//
//            return cell
//        case 4:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailsAddCommentCell.reuseId, for: indexPath) as! DetailsAddCommentCell
//
//            cell.completion = {[weak self] comment in
//                guard let _ = self else { return }
//                print(comment)
//            }
//            return cell
//        case 5:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailsMapCell.reuseId, for: indexPath) as! DetailsMapCell
//            cell.configureCell(coordinate: item.location)
//            return cell
//        default:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
//            cell.backgroundColor = .red
//            return cell
//        }
//
//
//    }
//
//
//}
//
//extension DetailsView: UICollectionViewDelegate{
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if indexPath.section == 0{
//            let itemPhoto = presenter.item.photos[indexPath.item]
//            photoView = Builder.createPhotoViewController(image: UIImage(named: itemPhoto)) as? PhotoView
//
//            if photoView != nil {
//                addChild(photoView!)
//                photoView!.view.frame = view.bounds
//                view.addSubview(photoView!.view)
//
//                photoView!.comletion = { [weak self] in
//                    self?.photoView!.view.removeFromSuperview()
//                    self?.photoView!.removeFromParent()
//                    self?.photoView = nil
//                }
//            }
//
//        }
//    }
//}
//
//
//extension DetailsView: DetailsViewProtocol {
//
//}
//
//
////
////  DetailsAddCommentCell.swift
////  instaPocket
////
////  Created by Ислам Батыргереев on 17.01.2024.
////
//
//import UIKit
//
//class DetailsAddCommentCell: UICollectionViewCell, CollectionViewCellProtocol {
//    static var reuseId: String = "DetailsAddCommentCell"
//
//    var completion: ((String) -> ())?
//
//    lazy var action = UIAction { [weak self] sender in
//        let textField = sender.sender as! UITextField
//        self?.completion?(textField.text ?? "")
//        self?.endEditing(true)
//    }
//
//    lazy var textField: UITextField = {
//        $0.backgroundColor = .white
//        $0.layer.cornerRadius = bounds.height/2
//        $0.placeholder = "Добавить комментарий"
//        $0.setLeftOffset()
//        return $0
//    }(UITextField(frame: bounds, primaryAction: action))
//
//    required override init(frame: CGRect) {
//        super.init(frame: frame)
//        addSubview(textField)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
////
////  DetailsDescriptionCell.swift
////  instaPocket
////
////  Created by Ислам Батыргереев on 17.01.2024.
////
//
//import UIKit
//
//class DetailsDescriptionCell: UICollectionViewCell, CollectionViewCellProtocol {
//    static let reuseId: String = "DetailsDescriptionCell"
//
//    lazy var dateTextLabel = UILabel()
//    lazy var descriptionTextLabel = UILabel()
//
//    lazy var cellStack: UIStackView = {
//        .configure(view: $0) { stack in
//            stack.alignment = .leading
//            stack.axis = .vertical
//            stack.spacing = 7
//        }
//    }(UIStackView())
//
//    required override init(frame: CGRect) {
//        super.init(frame: frame)
//        addSubview(cellStack)
//        backgroundColor = .appBlack
//        layer.cornerRadius = 30
//        clipsToBounds = true
//
//        NSLayoutConstraint.activate([
//            cellStack.topAnchor.constraint(equalTo: topAnchor, constant: 25),
//            cellStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
//            cellStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
//            cellStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25),
//        ])
//    }
//
//    func configureCell(date: Date?, text: String){
//        if date != nil {
//            dateTextLabel = creteCellLabel(text: date?.formattDate(formatType: .onlyDate) ?? "", weight: .bold)
//            cellStack.addArrangedSubview(dateTextLabel)
//        }
//
//        descriptionTextLabel = creteCellLabel(text: text, weight: .regular)
//        cellStack.addArrangedSubview(descriptionTextLabel)
//    }
//
//    private func creteCellLabel(text: String, weight: UIFont.Weight) -> UILabel{
//        let label = UILabel()
//        label.text = text
//        label.numberOfLines = 0
//        label.font = UIFont.systemFont(ofSize: 15, weight: weight)
//        label.textColor = .white
//        return label
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}
//
////
////  DetailsMapCell.swift
////  instaPocket
////
////  Created by Ислам Батыргереев on 17.01.2024.
////
//
//import UIKit
//import MapKit
//
//class DetailsMapCell: UICollectionViewCell, CollectionViewCellProtocol {
//    static var reuseId: String = "DetailsMapCell"
//
//    lazy var mapView: MKMapView = {
//        $0.layer.cornerRadius = 30
//        return $0
//    }(MKMapView(frame: bounds))
//
//    required override init(frame: CGRect) {
//        super.init(frame: frame)
//        addSubview(mapView)
//    }
//
//    func configureCell(coordinate: CLLocationCoordinate2D?){
//        guard let coordinate = coordinate else { return }
//        mapView.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
//
//        let pin = MKPointAnnotation()
//        pin.coordinate = coordinate
//        mapView.addAnnotation(pin)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//
//}
//
////
////  DetailsPhotoCell.swift
////  instaPocket
////
////  Created by Ислам Батыргереев on 17.01.2024.
////
//
//import UIKit
//
//class DetailsPhotoCell: UICollectionViewCell, CollectionViewCellProtocol {
//    static let reuseId: String = "DetailsPhotoCell"
//
//    lazy var cellImage: UIImageView = {
//        $0.contentMode = .scaleAspectFill
//        $0.clipsToBounds = true
//        return $0
//    }(UIImageView(frame: bounds))
//
//    lazy var imageMenuButton: UIButton = {
//        $0.setBackgroundImage(.dottetIcon, for: .normal)
//        $0.frame = CGRect(x: cellImage.frame.width - 50, y: 30, width: 31, height: 6)
//        return $0
//    }(UIButton())
//
//    required override init(frame: CGRect) {
//         super.init(frame: frame)
//        layer.cornerRadius = 30
//        clipsToBounds = true
//        addSubview(cellImage)
//        cellImage.addSubview(imageMenuButton)
//    }
//
//    func configureCell(image: String){
//        cellImage.image = UIImage(named: image)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}




// MARK: - how to communicate with HeaderView: UICollectionReusableView

// ....

//lazy var collectionView: UICollectionView = {
//    $0.backgroundColor = .clear
//    $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    $0.translatesAutoresizingMaskIntoConstraints = false
//    $0.dataSource = self
//    $0.delegate = self
//    $0.register(MallCell.self, forCellWithReuseIdentifier: MallCell.reuseID)
//    $0.register(BrandCellMallVC.self, forCellWithReuseIdentifier: BrandCellMallVC.reuseID)
//    $0.register(NavigationMallCell.self, forCellWithReuseIdentifier: NavigationMallCell.reuseID)
//    $0.register(MapCell.self, forCellWithReuseIdentifier: MapCell.reuseID)
//
//    $0.register(HeaderTitleSection.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderTitleSection.headerIdentifier)
//    $0.register(PagingSectionFooterView.self, forSupplementaryViewOfKind: "FooterMall", withReuseIdentifier: PagingSectionFooterView.footerIdentifier)
//    return $0
//}(UICollectionView(frame: .zero, collectionViewLayout: getCompositionLayout()))
//
//weak var footerMallDelegate: PageFooterMallDelegate?
//var currentPage: Int?

// ....

//func mallSections() -> NSCollectionLayoutSection {
//
//    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
//    let item = NSCollectionLayoutItem(layoutSize: itemSize)
//    item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
//    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.6))
//    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//    group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
//
//    let section = NSCollectionLayoutSection(group: group)
//    section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 5, trailing: 0)
//    //        groupPagingCentered
//    //        section.orthogonalScrollingBehavior = .paging
//    section.orthogonalScrollingBehavior = .groupPagingCentered
////        section.orthogonalScrollingBehavior = .continuous
//
////        let sizeFooter = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(20))
//    let sizeFooter = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(10))
//    let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sizeFooter, elementKind: "FooterMall", alignment: .bottom)
////        footer.pinToVisibleBounds = true
//    section.boundarySupplementaryItems = [footer]
//
//    section.visibleItemsInvalidationHandler = { [weak self] (visibleItems, offset, env) -> Void in
//        guard let self = self else {return}
//        let newPage = visibleItems.last?.indexPath.row ?? 0
//        if newPage != self.currentPage {
//            print("visibleItemsInvalidationHandler")
//            self.currentPage = newPage
//            self.footerMallDelegate?.currentPage(index: newPage)
//        }
//    }
//    return section
//}

// ....

//func buttonSection() -> NSCollectionLayoutSection {
//    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
//    let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
//    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//
//    let section = NSCollectionLayoutSection(group: group)
//    section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
//    let sizeHeader = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(20))
//    let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sizeHeader, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
//    section.boundarySupplementaryItems = [header]
//    return section
//}

// ....

//func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//    if kind == UICollectionView.elementKindSectionHeader {
//        switch indexPath.section {
//        case 1:
//            let title = R.Strings.OtherControllers.Mall.titleBtnStack
//            return createHeaderView(collectionView, title: title, kind: kind, indexPath: indexPath)
//        case 2:
//            let title = R.Strings.OtherControllers.Mall.shopsForMall
//            return createHeaderView(collectionView, title: title, kind: kind, indexPath: indexPath)
//        case 3:
//            let title = R.Strings.OtherControllers.Mall.titleMapView
//            return createHeaderView(collectionView, title: title, kind: kind, indexPath: indexPath)
//        default:
//            return UICollectionReusableView()
//        }
//    } else if kind == "FooterMall" {
//        guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PagingSectionFooterView.footerIdentifier, for: indexPath) as? PagingSectionFooterView else {
//            return UICollectionReusableView()
//        }
//        self.footerMallDelegate = footerView
//        let itemCount =  dataCollectionView[indexPath.section].items.count
//        footerView.configure(with: itemCount)
//        return footerView
//    } else {
//        return UICollectionReusableView()
//    }
//}

//private func createHeaderView(_ collectionView: UICollectionView, title: String, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
//    guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderTitleSection.headerIdentifier, for: indexPath) as? HeaderTitleSection else {
//        return UICollectionReusableView()
//    }
//    headerView.configureCell(title: title)
//    return headerView
//}

// ....

//import UIKit
//
//protocol PageFooterMallDelegate: AnyObject {
//    func currentPage(index: Int)
//}
//class PagingSectionFooterView: UICollectionReusableView {
//    static let footerIdentifier = "FooterMall"
//    lazy var pageControl: UIPageControl = {
//        let control = UIPageControl()
//        control.currentPage = 0
//        control.translatesAutoresizingMaskIntoConstraints = false
//        control.isUserInteractionEnabled = false
//        control.currentPageIndicatorTintColor = R.Colors.label
//        control.pageIndicatorTintColor = R.Colors.systemGray
//        return control
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupView()
//        backgroundColor = .clear
//    }
//    func configure(with numberOfPages: Int) {
//        pageControl.numberOfPages = numberOfPages
//    }
//
//    private func setupView() {
//        addSubview(pageControl)
//        NSLayoutConstraint.activate([
//            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
//            pageControl.topAnchor.constraint(equalTo: topAnchor, constant: 0),
//            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
//        ])
//        }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//extension PagingSectionFooterView: PageFooterMallDelegate {
//    func currentPage(index: Int) {
//        pageControl.currentPage = index
//        print("PagingSectionDelegate")
//    }
//}
//
//





// MARK: - CollectionView with CompositionLayout in ScrollView


//Controller


//final class MallController: UIViewController {
//
//    var heightCnstrCollectionView: NSLayoutConstraint!
//
//    private let scrollView: UIScrollView = {
//        let scroll = UIScrollView()
//        scroll.translatesAutoresizingMaskIntoConstraints = false
//        return scroll
//    }()
//
//    private let containerView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .clear
//        return view
//    }()
//
//    private var mapView: MapView!
//
//    private let mapTapGestureRecognizer: UITapGestureRecognizer = {
//        let tapRecognizer = UITapGestureRecognizer()
//        tapRecognizer.numberOfTapsRequired = 1
//        return tapRecognizer
//    }()
//
//    private var collectionView:MallCollectionView!
//
//    private var isMapSelected = false
//
//    private var floorPlanBtn: UIButton!
//    private var webPageForMallBtn: UIButton!
//
//    private let compositeNavigationStck: UIStackView = {
//        let stack = UIStackView()
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        stack.axis = .vertical
//        stack.distribution = .fill
//        stack.spacing = 20
//        return stack
//    }()
//
//    private var mallModel: MallModelInput?
//    private var dataMall: Mall?
//    private var arrayPin:[Places] = []
//    private var dataCollectionView:[SectionModel] = []
//
//    private var navController: NavigationController? {
//            return self.navigationController as? NavigationController
//        }
//
//    init(modelInput: MallModelInput, title:String) {
//        self.mallModel = modelInput
//        super.init(nibName: nil, bundle: nil)
//        self.title = title
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = R.Colors.systemBackground
//        fetchProduct()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//    }
//
//    /// Метод viewDidLayoutSubviews() вызывается после того, как система завершает автоматическую настройку размеров и позиций подвидов для UIViewController.
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        /// collectionView.collectionViewLayout.collectionViewContentSize.height - не сразу высчитывается на это нужно время
//        guard let collectionView = collectionView else { return }
//        print("viewDidLayoutSubviews() - \(collectionView.collectionViewLayout.collectionViewContentSize.height)")
//        if Int(collectionView.collectionViewLayout.collectionViewContentSize.height) == 0 {
//            heightCnstrCollectionView.constant = 200
//        } else {
//            heightCnstrCollectionView.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
//        }
//
//        /// layoutIfNeeded в UIKit немедленно применяет любые отложенные обновления макета. Если вы вызываете layoutIfNeeded, система проверяет, есть ли какие-либо отложенные изменения в макете, и если они есть, система немедленно обновляет макет.
//        /// Отложенные изменения в макете обычно происходят, когда вы вносите изменения в данные, которые используются для создания макета вашего UICollectionView(Добавляете, удаляете или перемещаете ячейки, Изменяете размер или положение ячеек, Изменяете макет UICollectionView)
//        ///  layoutIfNeeded может потенциально привести к дополнительным вычислениям макета. Это может повлиять на производительность.
//        /// Однако важно отметить, что layoutIfNeeded будет выполнять работу только в том случае, если есть отложенные изменения макета. Если нет отложенных изменений, layoutIfNeeded не будет делать ничего, и его влияние на производительность будет минимальным.
//    }
//}
//
//// MARK: - Setting Views
//private extension MallController {
//    func setupView() {
//        //        navigationItem.largeTitleDisplayMode = .never
//        setupScrollView()
//        setupCollectionView()
//        setupMapView()
//        setupBtn()
//        setupSubviews()
//        setupConstraints()
//    }
//}
//
//// MARK: - Setting
//private extension MallController {
//
//    func setupScrollView() {
//        view.addSubview(scrollView)
//        scrollView.addSubview(containerView)
//
//        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
//        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//
//        containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
//        containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
//        containerView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
//        containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
//        containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
//    }
//
//    func setupCollectionView() {
//        collectionView = MallCollectionView()
//        collectionView.delegate = self
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.reloadData(data: dataCollectionView)
//        heightCnstrCollectionView = collectionView.heightAnchor.constraint(equalToConstant: 10)
//        heightCnstrCollectionView.isActive = true
//    }
//
//    func createButton(withTitle title: String, textColor: UIColor, fontSize: CGFloat, target: Any?, action: Selector, image: UIImage.SymbolConfiguration?) -> UIButton {
//        var configuration = UIButton.Configuration.gray()
//        configuration.titleAlignment = .center
//        configuration.buttonSize = .large
//        configuration.baseBackgroundColor = R.Colors.systemPurple
//        configuration.imagePlacement = .trailing
//        configuration.imagePadding = 8.0
//        configuration.preferredSymbolConfigurationForImage = image
//        var container = AttributeContainer()
//        container.font = UIFont.boldSystemFont(ofSize: fontSize)
//        container.foregroundColor = textColor
//        let attributedTitle = AttributedString(title, attributes: container)
//
//        configuration.attributedTitle = attributedTitle
//
//        let button = UIButton(configuration: configuration)
//        button.tintColor = R.Colors.label
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(target, action: action, for: .touchUpInside)
//
//        return button
//    }
//
//    func createStackViewWithBtns(buttons: [UIButton]) -> UIStackView {
//        let stackViewForButton: UIStackView = {
//            let stack = UIStackView(arrangedSubviews: buttons)
//            stack.translatesAutoresizingMaskIntoConstraints = false
//            stack.axis = .vertical
//            stack.distribution = .fill
//            stack.spacing = 5
//            return stack
//        }()
//        return stackViewForButton
//    }
//    func createStackViewWithBtns(firstButton: UIButton, secondButton: UIButton) -> UIStackView {
//        let stackViewForButton: UIStackView = {
//            let stack = UIStackView(arrangedSubviews: [firstButton, secondButton])
//            stack.translatesAutoresizingMaskIntoConstraints = false
//            stack.axis = .vertical
//            stack.distribution = .fill
//            stack.spacing = 5
//            return stack
//        }()
//        return stackViewForButton
//    }
//
//    func setupBtn() {
//
//        let titleBtnStack: UILabel = {
//            let label = UILabel()
//            label.translatesAutoresizingMaskIntoConstraints = false
//            label.text = R.Strings.OtherControllers.Mall.titleBtnStack
//            label.numberOfLines = 0
//            label.textAlignment = .left
//            label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
//            label.textColor = R.Colors.label
//            label.heightAnchor.constraint(equalToConstant: 30).isActive = true
//            return label
//        }()
//
//        let titleMapView: UILabel = {
//            let label = UILabel()
//            label.translatesAutoresizingMaskIntoConstraints = false
//            label.text = R.Strings.OtherControllers.Mall.titleMapView
//            label.numberOfLines = 0
//            label.textAlignment = .left
//            label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
//            label.textColor = R.Colors.label
//            return label
//        }()
//
//        var buttons = [UIButton]()
//
//        if dataMall?.webSite != nil {
//            webPageForMallBtn = createButton(withTitle: R.Strings.OtherControllers.Mall.webPageForMallBtn, textColor: R.Colors.label, fontSize: 15, target: self, action: #selector(webPageForMallPressed(_:)), image: UIImage.SymbolConfiguration(scale: .large))
//            buttons.append(webPageForMallBtn)
//        }
//
//        if dataMall?.floorPlan != nil {
//            floorPlanBtn = createButton(withTitle: R.Strings.OtherControllers.Mall.floorPlanBtn, textColor: R.Colors.label, fontSize: 15, target: self, action: #selector(floorPlanBtnPressed(_:)), image: UIImage.SymbolConfiguration(scale: .large))
//
//            buttons.append(floorPlanBtn)
//        }
//        let btnStack = createStackViewWithBtns(buttons: buttons)
//        let subviews = [titleBtnStack, btnStack, titleMapView]
//        subviews.forEach { compositeNavigationStck.addArrangedSubview($0) }
//    }
//
//    func setupMapView() {
//
//        mapView = MapView(places:arrayPin)
//        mapView.translatesAutoresizingMaskIntoConstraints = false
//        mapView.layer.cornerRadius = 10
//        mapView.isZoomEnabled = false
//        mapView.isScrollEnabled = false
//        mapView.isPitchEnabled = false
//        mapView.isRotateEnabled = false
//        mapView.delegateMap = self
//        mapTapGestureRecognizer.addTarget(self, action: #selector(didTapRecognizer(_:)))
//        mapView.addGestureRecognizer(mapTapGestureRecognizer)
//    }
//
//    func setupSubviews() {
//        containerView.addSubview(collectionView)
//        containerView.addSubview(compositeNavigationStck)
//        containerView.addSubview(mapView)
//    }
//
//    ///  Duplicate the code
//    ///  можно перенести в Application Model как static method in da class
//    func getMapPin(pins:[Pin]) {
//        pins.forEach { pin in
//            if let latitude = pin.latitude, let longitude = pin.longitude {
//                let pinMap = Places(title: pin.name, locationName: pin.address, discipline: pin.typeMall, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), imageName: pin.refImage)
//                self.arrayPin.append(pinMap)
//            }
//        }
//    }
//
//    func startLoad() {
//        startSpiner()
//    }
//
//    func stopLoad() {
//        stopSpiner()
//    }
//
//    func startSpiner() {
//        navController?.startSpinnerForView()
//    }
//
//    func stopSpiner() {
//        navController?.stopSpinner()
//    }
//}
//
//// MARK: - Selectors
//private extension MallController {
//    @objc func webPageForMallPressed(_ sender: UIButton) {
//        guard let urlString = dataMall?.webSite else { return }
//        self.presentSafariViewController(withURL: urlString)
//    }
//
//    @objc func floorPlanBtnPressed(_ sender: UIButton) {
//        guard let urlString = dataMall?.floorPlan else { return }
//        self.presentSafariViewController(withURL: urlString)
//    }
//
//    /// Duplicate the code
//    @objc func didTapRecognizer(_ gestureRecognizer: UITapGestureRecognizer) {
//
//        let point = gestureRecognizer.location(in: mapView)
//        var didTapOnAnnotationView = false
//        /// Находится ли точка нажатия внутри annotationMarker
//        for annotation in mapView.annotations {
//            guard let annotationView = mapView.view(for: annotation),
//                  let annotationMarker = annotationView as? MKMarkerAnnotationView,
//                  annotationMarker.point(inside: mapView.convert(point, to: annotationMarker), with: nil)
//                    /// Если условие guard не выполняется, цикл продолжается с следующей аннотацией.
//            else {
//                continue
//            }
//            /// Если условие guard выполняется, то есть нажатие было на представление аннотации, переменная didTapOnAnnotationView устанавливается в true и цикл прерывается.
//            didTapOnAnnotationView = true
//            break
//        }
//
//        if !didTapOnAnnotationView && isMapSelected == false {
//            let fullScreenMap = MapController(arrayPin: [Places]())
//            fullScreenMap.modalPresentationStyle = .fullScreen
//            present(fullScreenMap, animated: true, completion: nil)
//        }
//    }
//}
//
//// MARK: - Layout
//private extension MallController {
//    func setupConstraints() {
//        collectionView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
//        collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0).isActive = true
//        collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0).isActive = true
//        collectionView.bottomAnchor.constraint(equalTo: compositeNavigationStck.topAnchor, constant: -20).isActive = true
//        compositeNavigationStck.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
//        compositeNavigationStck.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
//        compositeNavigationStck.bottomAnchor.constraint(equalTo: mapView.topAnchor, constant: -20).isActive = true
//        mapView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
//        mapView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
//        mapView.heightAnchor.constraint(equalTo: mapView.widthAnchor, multiplier: 1).isActive = true
//        mapView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0).isActive = true
//    }
//}
//
//// MARK: - UICollectionViewDelegate
//extension MallController: UICollectionViewDelegate {
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        switch indexPath.section {
//        case 0:
//            print("DidTap Mall Section")
//        case 1:
//            // при Cloud Firestore мы будем в NC переходить на VC с вертикальной прокруткой collectionView и cell как у popularProduct
////            let brandVC = UIStoryboard.vcById("BrandsViewController") as! BrandsViewController
////            let refPath = section[indexPath.section].items[indexPath.row].brands?.brand ?? ""
////            brandVC.pathRefBrandVC = refPath
////            brandVC.title = refPath
////            brandVC.arrayPin = arrayPin
////            self.navigationController?.pushViewController(brandVC, animated: true)
//            print("DidTap Shop Section")
//        default:
//            print("DidTap Default Section")
//        }
//    }
//}
//
//// MARK: - Setting DataSource
//private extension MallController {
//    func fetchProduct() {
//        startLoad()
//        mallModel?.fetchMall(completion: { [weak self] (mallModel, dataCollectionView, pins, error) in
//            guard let self = self else { return }
//            self.stopLoad()
//            guard let mallModel = mallModel, error == nil, let pins = pins, let dataCollectionView = dataCollectionView else {
//                self.showErrorAlert(message: error?.localizedDescription ?? "Something went wrong!", state: .followingDataUpdate) {
//                    self.fetchProduct()
//                } cancelActionHandler: {
//                    self.navigationController?.popViewController(animated: true)
//                }
//                return
//            }
//            self.getMapPin(pins: pins)
//            self.dataMall = mallModel
//            self.dataCollectionView = dataCollectionView
//            self.setupView()
//        })
//    }
//}
//
//// MARK: - MapViewManagerDelegate
//extension MallController: MapViewManagerDelegate {
//    func selectAnnotationView(isSelect: Bool) {
//        isMapSelected = isSelect
//    }
//}
//





// Views



//import UIKit
//
//
//final class MallCollectionView: UICollectionView {
//
//    private var data:[SectionModel] = [] {
//        didSet {
//            reload()
//        }
//    }
//    weak var footerMallDelegate: PageFooterMallDelegate?
//    var currentPage: Int?
//
//    private var collectionViewDataSource: UICollectionViewDiffableDataSource<SectionModel, Item>?
//
//    init() {
//        super.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
//        let layout = self.createLayout()
//        self.collectionViewLayout = layout
//        self.setupView()
//    }
//
//        required init?(coder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
//}
//
//// MARK: - Setting Views
//private extension MallCollectionView {
//    func setupView() {
//        backgroundColor = .clear
//        createDataSource()
//        registerView()
//    }
//}
//
//// MARK: - Setting CollectionView
//private extension MallCollectionView {
//
//    func createLayout() -> UICollectionViewLayout {
//
//        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
//            let section = self?.data[sectionIndex]
//
//            switch section?.section {
//            case "Mall":
//                return self?.mallSections()
//            case "Shop":
//                return self?.shopSection()
//            default:
//                return self?.defaultSection()
//            }
//        }
//    return layout
//    }
//
//    func mallSections() -> NSCollectionLayoutSection {
//
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.55))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
//
//        let section = NSCollectionLayoutSection(group: group)
//        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
//        //        groupPagingCentered
//        //        section.orthogonalScrollingBehavior = .paging
//        section.orthogonalScrollingBehavior = .groupPagingCentered
//
//        let sizeFooter = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(20))
//        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sizeFooter, elementKind: "FooterMall", alignment: .bottom)
//        section.boundarySupplementaryItems = [footer]
//
//        section.visibleItemsInvalidationHandler = { [weak self] (visibleItems, offset, env) -> Void in
//            guard let self = self else {return}
//            let newPage = visibleItems.last?.indexPath.row ?? 0
//            if newPage != self.currentPage {
//                self.currentPage = newPage
//                self.footerMallDelegate?.currentPage(index: newPage)
//            }
//        }
//        return section
//    }
//
//    func shopSection() -> NSCollectionLayoutSection {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(20) )
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: NSCollectionLayoutSpacing.fixed(10), trailing: nil, bottom: nil)
//
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(20))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
//        group.interItemSpacing = .fixed(10)
//
//        let section = NSCollectionLayoutSection(group: group)
//        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
//
//        let sizeHeader = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(20))
//        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sizeHeader, elementKind: "HeaderBrands", alignment: .top)
//        header.pinToVisibleBounds = true
//        section.boundarySupplementaryItems = [header]
//        return section
//    }
//
//    func defaultSection() -> NSCollectionLayoutSection {
//        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
//        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitem: item, count: 0)
//        let section = NSCollectionLayoutSection(group: group)
//        return section
//    }
//
//    func createDataSource() {
//
//        collectionViewDataSource = UICollectionViewDiffableDataSource<SectionModel, Item>(collectionView: self, cellProvider: { collectionView, indexPath, cellData in
//            switch self.data[indexPath.section].section {
//            case "Mall":
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MallCell.reuseID, for: indexPath) as? MallCell
//                cell?.configureCell(model: cellData, isHiddenTitle: true)
//                return cell
//            case "Shop":
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BrandCellMallVC.reuseID, for: indexPath) as? BrandCellMallVC
//                cell?.configureCell(model: cellData)
//                return cell
//            default:
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BrandCellMallVC.reuseID, for: indexPath) as? BrandCellMallVC
//                cell?.configureCell(model: cellData)
//                return cell
//            }
//        })
//
//        collectionViewDataSource?.supplementaryViewProvider = { collectionView, kind, IndexPath in
//
//            if kind == "FooterMall" {
//                let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: PagingSectionFooterView.footerIdentifier, withReuseIdentifier: PagingSectionFooterView.footerIdentifier, for: IndexPath) as? PagingSectionFooterView
//                let itemCount = self.collectionViewDataSource?.snapshot().numberOfItems(inSection: self.data[IndexPath.section])
//                footerView?.configure(with: itemCount ?? 0)
//                self.footerMallDelegate = footerView
//                return footerView
//            } else if kind == "HeaderBrands" {
//                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: HeaderBrandsMallView.headerIdentifier, withReuseIdentifier: HeaderBrandsMallView.headerIdentifier, for: IndexPath) as? HeaderBrandsMallView
//                headerView?.configureCell(title: "Brands for mall")
//                return headerView
//            } else {
//                return nil
//            }
//        }
//    }
//
//    func registerView() {
//        register(MallCell.self, forCellWithReuseIdentifier: MallCell.reuseID)
//        register(BrandCellMallVC.self, forCellWithReuseIdentifier: BrandCellMallVC.reuseID)
//        register(PagingSectionFooterView.self, forSupplementaryViewOfKind: "FooterMall", withReuseIdentifier: PagingSectionFooterView.footerIdentifier)
//        register(HeaderBrandsMallView.self, forSupplementaryViewOfKind: "HeaderBrands", withReuseIdentifier: HeaderBrandsMallView.headerIdentifier)
//    }
//
//    func reload() {
//
//        var snapshot = NSDiffableDataSourceSnapshot<SectionModel, Item>()
//        snapshot.appendSections(data)
//
//        for section in data {
//            snapshot.appendItems(section.items, toSection: section)
//        }
//        collectionViewDataSource?.apply(snapshot)
//
//    }
//}
//
//// MARK: - Setting DataSource
//extension MallCollectionView {
//    func reloadData(data: [SectionModel]) {
//        self.data = data
//    }
//}




//import UIKit
//
//protocol PageFooterMallDelegate: AnyObject {
//    func currentPage(index: Int)
//}
//class PagingSectionFooterView: UICollectionReusableView {
//    static let footerIdentifier = "FooterMall"
//    lazy var pageControl: UIPageControl = {
//        let control = UIPageControl()
//        control.currentPage = 0
//        control.translatesAutoresizingMaskIntoConstraints = false
//        control.isUserInteractionEnabled = false
//        control.currentPageIndicatorTintColor = R.Colors.label
//        control.pageIndicatorTintColor = R.Colors.systemGray
//        return control
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupView()
//        backgroundColor = .clear
//    }
//    func configure(with numberOfPages: Int) {
//        pageControl.numberOfPages = numberOfPages
//    }
//
//    private func setupView() {
//        addSubview(pageControl)
//        NSLayoutConstraint.activate([
//            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
//            pageControl.topAnchor.constraint(equalTo: topAnchor, constant: 0),
//            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
//        ])
//        }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//extension PagingSectionFooterView: PageFooterMallDelegate {
//    func currentPage(index: Int) {
//        pageControl.currentPage = index
//        print("PagingSectionDelegate")
//    }
//}
//



//import UIKit
//
//class HeaderBrandsMallView: UICollectionReusableView {
//
//    static let headerIdentifier = "HeaderBrands"
//    let label:UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textAlignment = .left
//        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
//        label.backgroundColor = .clear
//        label.tintColor = R.Colors.label
//        label.numberOfLines = 0
//        return label
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        addSubview(label)
//        setupConstraints()
//        backgroundColor = .clear
//    }
//
//    private func setupConstraints() {
//        NSLayoutConstraint.activate([label.topAnchor.constraint(equalTo: topAnchor, constant: 5), label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5), label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0), label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)])
//    }
//
//    func configureCell(title: String) {
//        label.text = title
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        addSubview(label)
//        setupConstraints()
//        backgroundColor = .white
////        fatalError("init(coder:) has not been implemented")
//    }
//}


//class BrandCellMallVC: UICollectionViewCell {
//
//    static var reuseID: String = "BrandCell"
//    var storage: Storage!
//
//    let containerView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .systemRed
//        return view
//    }()
//
//    let imageView: UIImageView = {
//        let image = UIImageView()
//        image.translatesAutoresizingMaskIntoConstraints = false
//        image.contentMode = .scaleAspectFit
//        image.layer.cornerRadius = 10
//        image.tintColor = R.Colors.label
//        image.backgroundColor = R.Colors.secondarySystemBackground
//        image.layer.cornerRadius = 10
//        image.clipsToBounds = true
//        return image
//    }()
//
//    let nameShopLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textAlignment = .center
//        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
//        label.textColor = R.Colors.label
//        label.backgroundColor = R.Colors.secondarySystemBackground
//        label.layer.cornerRadius = 10
//        label.clipsToBounds = true
//        label.isHidden = true
//        return label
//    }()
//
//    let floorLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textAlignment = .left
//        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
//        label.textColor = R.Colors.secondaryLabel
//        label.backgroundColor = .clear
//        return label
//    }()
//
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        contentView.backgroundColor = .clear
//        storage = Storage.storage()
//        contentView.addSubview(imageView)
//        contentView.addSubview(nameShopLabel)
//        contentView.addSubview(floorLabel)
//        setupConstraints()
//    }
//
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        imageView.isHidden = false
//        nameShopLabel.isHidden = true
//
////        imageView.sd_cancelCurrentImageLoad()
////        imageView.image = nil
//    }
//
//    private func setupConstraints() {
//
//
//        // Определение ограничений для imageView, floorLabel и nameShopLabel
//        NSLayoutConstraint.activate([
//            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
//
//            floorLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
//            floorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            floorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//
//            nameShopLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            nameShopLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            nameShopLabel.heightAnchor.constraint(equalTo: nameShopLabel.widthAnchor)
//        ])
//
//        // Определение ограничения для верхнего края imageView
//        let imageViewTopConstraint = imageView.topAnchor.constraint(equalTo: contentView.topAnchor)
//        imageViewTopConstraint.priority = UILayoutPriority(999)
//        imageViewTopConstraint.isActive = true
//
//        // Определение ограничения для верхнего края nameShopLabel
//        let nameShopTopConstraint = nameShopLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
//        nameShopTopConstraint.priority = UILayoutPriority(999)
//        nameShopTopConstraint.isActive = true
//
//        // Определение ограничения для нижнего края floorLabel
//        let floorLabelBottomConstraint = floorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
//        floorLabelBottomConstraint.priority = UILayoutPriority(999)
//        floorLabelBottomConstraint.isActive = true
//    }
//
//    func configureCell(model: Item) {
//        let placeholderImage = UIImage(systemName: "photo")
//        if let urlString = model.shop?.logo {
//            let urlRef = storage.reference(forURL: urlString)
//            imageView.sd_setImage(with: urlRef, placeholderImage: placeholderImage) { (image, error, cacheType, url) in
//                guard let image = image, error == nil else {
//
//                    // Обработка ошибок
//                    self.imageView.image = placeholderImage
//                    print("Returned message for analytic FB Crashlytics error ShopCell - \(String(describing: error?.localizedDescription))")
//                    return
//                }
//                // Настройка цвета изображения в зависимости от текущей темы
//                if #available(iOS 13.0, *) {
//                    let tintableImage = image.withRenderingMode(.alwaysTemplate)
//                    self.imageView.image = tintableImage
//                } else {
//                    self.imageView.image = image
//                }
//            }
//        }else {
//            imageView.isHidden = true
//            nameShopLabel.isHidden = false
//            nameShopLabel.text = model.shop?.name
//        }
//
//        if let floor = model.shop?.floor {
//            floorLabel.text = floor
//        }
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//
//}
