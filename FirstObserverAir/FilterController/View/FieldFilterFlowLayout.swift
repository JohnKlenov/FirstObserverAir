//
//  FieldFilterFlowLayout.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 7.02.24.
//

import UIKit

//layoutAttributesForElements(in:) - это метод, который вызывается системой для получения атрибутов макета для всех элементов в заданном прямоугольнике. Это включает ячейки, заголовки и подзаголовки.
//super.layoutAttributesForElements(in: rect) - вызывает родительскую реализацию этого метода, чтобы получить начальные атрибуты макета.
//NSArray(array: attributesForElementsInRect, copyItems: true) as? [UICollectionViewLayoutAttributes] - создает копию этих атрибутов, чтобы их можно было безопасно изменять.
//var leftMargin: CGFloat = 0.0 - это переменная, которая используется для отслеживания текущего отступа слева при выравнивании ячеек по левому краю.
//Затем код проходит через каждый элемент в newAttributesForElementsInRect:
//Если элемент является заголовком (attributes.representedElementKind == UICollectionView.elementKindSectionHeader), он пропускает его и переходит к следующему элементу.
//Если x координата элемента равна sectionInset.left, это означает, что элемент находится в начале новой строки, и leftMargin обновляется до sectionInset.left.
//В противном случае, x координата элемента обновляется до текущего значения leftMargin, выравнивая элемент по левому краю.
//leftMargin затем увеличивается на ширину текущего элемента плюс 8 (для пространства между ячейками).

//В конце, метод возвращает обновленные атрибуты макета.
//Этот код обеспечивает выравнивание ячеек по левому краю в каждой строке, вместо стандартного поведения UICollectionViewFlowLayout, которое центрирует ячейки. Он также обеспечивает корректное обновление атрибутов макета, копируя их перед изменением, чтобы избежать ошибок, связанных с изменением кэшированных атрибутов.

class UserProfileTagsFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributesForElementsInRect = super.layoutAttributesForElements(in: rect) else { return nil }
        guard let newAttributesForElementsInRect = NSArray(array: attributesForElementsInRect, copyItems: true) as? [UICollectionViewLayoutAttributes] else { return nil }

        var leftMargin: CGFloat = 0.0;

        for i in 0..<newAttributesForElementsInRect.count {
            let attributes = newAttributesForElementsInRect[i]
            
            // Проверяем, является ли элемент заголовком
            if attributes.representedElementKind == UICollectionView.elementKindSectionHeader {
                continue
            }
            
            if (attributes.frame.origin.x == self.sectionInset.left) {
                leftMargin = self.sectionInset.left
            }
            else {
                var newLeftAlignedFrame = attributes.frame
                newLeftAlignedFrame.origin.x = leftMargin
                attributes.frame = newLeftAlignedFrame
            }
            leftMargin += attributes.frame.size.width + 8 // Makes the space between cells
        }

        return newAttributesForElementsInRect
    }
}

