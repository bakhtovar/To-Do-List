//
//  TaskCollectionView.swift
//  To-Do List
//
//  Created by Bakhtovar Umarov on 07/04/23.
//


import UIKit
import SnapKit

class TaskCollectionViewCell: UICollectionViewCell {
 
    
    // MARK: - UI
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()

    public lazy var dueDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()

    public lazy var performerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        return view
    }()
    
    public lazy var commentView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = .black
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.layer.cornerRadius = 8
        textView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        return textView
    }()

    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        updateConstraints()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private
    private func addSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(commentView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(dueDateLabel)
        containerView.addSubview(performerLabel)
        
        setNeedsUpdateConstraints()
    }
    
    // MARK: - Lifecycle
    override func updateConstraints() {
        containerView.snp.updateConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }

        titleLabel.snp.updateConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(16)
        }

        dueDateLabel.snp.updateConstraints { make in
            make.leading.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }

        performerLabel.snp.updateConstraints { make in
            make.leading.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(16)
            make.top.equalTo(dueDateLabel.snp.bottom).offset(8)
        }

        commentView.snp.updateConstraints { make in
            make.leading.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(16)
            make.top.equalTo(performerLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(16)
        }

        super.updateConstraints()
    }
    
    //MARK: - Core Data
    func configure(with viewModel: TaskCollectionViewCellViewModel) {
        titleLabel.text = viewModel.title
        dueDateLabel.text = viewModel.dueDate
        performerLabel.text = viewModel.performer
        commentView.text = viewModel.commentsText
    }
}
