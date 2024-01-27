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
