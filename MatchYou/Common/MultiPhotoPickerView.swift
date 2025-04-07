//
//  MultiPhotoPickerView.swift
//  MatchYou
//
//  Created by 김견 on 3/19/25.
//

import UIKit
import SnapKit
import PhotosUI
import RxSwift
import RxCocoa

final class MultiPhotoPickerView: UIView, PHPickerViewControllerDelegate {
    //MARK: - Properties
    private let disposeBag = DisposeBag()
    private var selectedImagesSubject = BehaviorSubject<[UIImage]>(value: [])
    
    var selectedImages: Observable<[UIImage]> {
        return selectedImagesSubject.asObservable()
    }
    
    private var selectedImageCount: Observable<Int> {
        return selectedImagesSubject.map { $0.count }
    }
    
    //MARK: - View
    private let photoPickerView: PhotoPickerView = {
        let view = PhotoPickerView(selectedImageCount: 0)
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.itemSize = CGSize(width: 60, height: 60)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(PhotoContentCell.self, forCellWithReuseIdentifier: PhotoContentCell.identifier)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    //MARK: - Initialize
    init() {
        super.init(frame: .zero)
        
        setUI()
        setPhotoPickerAction()
        setBind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    private func setUI() {
        addSubview(photoPickerView)
        addSubview(collectionView)
        
        photoPickerView.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.left.top.bottom.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.equalTo(photoPickerView.snp.trailing).offset(8)
            make.top.bottom.trailing.equalToSuperview()
        }
        

    }
    
    //MARK: - Action
    private func setPhotoPickerAction() {
        photoPickerView.selectImageButton.rx.tap
            .bind { [weak self] in self?.presentPhotoPicker() }
            .disposed(by: disposeBag)
    }
    
    //MARK: - Photo
    private func presentPhotoPicker() {
        var phPickerConfiguration = PHPickerConfiguration()
        phPickerConfiguration.selectionLimit = 10
        phPickerConfiguration.filter = .images
        
        let phPickerViewController = PHPickerViewController(configuration: phPickerConfiguration)
        phPickerViewController.delegate = self
        
        if let viewController = findViewController() {
            viewController.present(phPickerViewController, animated: true, completion: nil)
        }
    }
    
    private func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            responder = nextResponder
            if let viewController = responder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    private func setBind() {
        selectedImages
            .observe(on: MainScheduler.instance)
            .bind(to: collectionView.rx.items(cellIdentifier: PhotoContentCell.identifier, cellType: PhotoContentCell.self)) { [weak self] index, image, cell in
                cell.configure(image: image) { [weak self] in
                    guard let self = self else { return }
                    do {
                        var images = try self.selectedImagesSubject.value()
                        guard index < images.count else { return }
                        images.remove(at: index)
                        self.selectedImagesSubject.onNext(images)
                    } catch {
                        print("Error fetching selected images: \(error)")
                    }
                }
            }
            .disposed(by: disposeBag)
        
        selectedImageCount
            .observe(on: MainScheduler.instance)
            .bind(to: photoPickerView.rx.selectedImageCount)
            .disposed(by: disposeBag)
        
        selectedImageCount
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] count in
                self?.photoPickerView.updateSelectedImageCount(count)
            })
            .disposed(by: disposeBag)
        
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        var currentImages = (try? selectedImagesSubject.value()) ?? []
        var newImages: [UIImage] = []
        let dispatchGroup = DispatchGroup()
        
        for result in results {
            let itemProvider = result.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                dispatchGroup.enter()
                itemProvider.loadObject(ofClass: UIImage.self) { image, _ in
                    if let image = image as? UIImage {
                        DispatchQueue.main.async {
                            newImages.append(image)
                        }
                    }
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            currentImages.append(contentsOf: newImages)
            self.selectedImagesSubject.onNext(currentImages)
            self.collectionView.reloadData()
        }
    }
}

final class PhotoPickerView: UIView {
    //MARK: - Properties
    var selectedImageCount: Int
    
    //MARK: - View
    let selectImageButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.matchYouSecondary.cgColor
        return button
    }()
    
    let cameraImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "camera"))
        imageView.tintColor = .matchYouSecondary
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    let selectedImageCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .matchYouSecondary
        label.textAlignment = .center
        label.isUserInteractionEnabled = false
        return label
    }()
    
    //MARK: - Initialize
    init(selectedImageCount: Int) {
        self.selectedImageCount = selectedImageCount
        super.init(frame: .zero)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    private func setUI() {
        
        
        selectedImageCountLabel.text = "\(selectedImageCount)/10"
        
        let stackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [cameraImageView, selectedImageCountLabel])
            stackView.axis = .vertical
            stackView.spacing = 4
            stackView.alignment = .center
            stackView.isUserInteractionEnabled = false
            return stackView
        }()
        
        selectImageButton.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.center.equalTo(selectImageButton)
            make.edges.equalTo(selectImageButton).inset(12)
        }
        
        addSubview(selectImageButton)
        
        selectImageButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        selectImageButton.isUserInteractionEnabled = true
    }
    
    func updateSelectedImageCount(_ count: Int) {
        selectedImageCountLabel.text = "\(count)/10"
    }
}

final class PhotoContentCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let identifier = "PhotoContentCell"
    
    private let photoContentView = PhotoContentView(image: UIImage())
    
    //MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    private func setUI() {
        contentView.addSubview(photoContentView)
        
        photoContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        self.isUserInteractionEnabled = true
    }
    
    //MARK: - Configure
    func configure(image: UIImage, onDelete: @escaping () -> Void) {
        photoContentView.setImage(image)
        photoContentView.onDelete = onDelete
    }
}


final class PhotoContentView: UIView {
    
    //MARK: - Properties
    private var image: UIImage
    var onDelete: (() -> Void)?
    
    //MARK: - View
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .custom)

            // 아이콘 설정
            let image = UIImage(systemName: "xmark")?.withConfiguration(
                UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)
            )
            button.setImage(image, for: .normal)
            button.tintColor = .white

            // 배경색, 모서리 둥글게 (원형)
            button.backgroundColor = .red
            button.layer.cornerRadius = 12
            button.clipsToBounds = true

            return button
    }()
    
    //MARK: - Initialize
    init(image: UIImage) {
        self.image = image
        super.init(frame: .zero)
        setUI()
        setActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        deleteButton.layer.cornerRadius = deleteButton.bounds.width / 2
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let convertedPoint = deleteButton.convert(point, from: self)

        if deleteButton.bounds.contains(convertedPoint) {
            return deleteButton
        }
        return super.hitTest(point, with: event)
    }
    
    //MARK: - UI
    private func setUI() {
        addSubview(imageView)
        addSubview(deleteButton)
        
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.center.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(imageView).inset(-8) // 이미지 뷰 기준!
            make.width.height.equalTo(16)
        }
        
    }
    
    //MARK: - Action
    private func setActions() {
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    @objc private func deleteButtonTapped() {
        onDelete?()
    }
    
    //MARK: - ETC
    func setImage(_ image: UIImage) {
        self.image = image
        imageView.image = image
    }
}
