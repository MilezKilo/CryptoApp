//
//  LocalFileManager.swift
//  CryptoApp
//
//  Created by Майлс on 23.12.2021.
//

import SwiftUI

class LocalFileManager {
    
    ///Синглетон, описывающий весь класс LocalFileManager
    static let instance = LocalFileManager()
    //Приватный инициализатор, не используется
    private init() { }
    
    ///Метод сохранения полученного изображения
    func saveImage(image: UIImage, imageName: String, folderName: String) {
        
        //Создание папки
        createFolderIfNeeded(folderName: folderName)
        
        //Получения пути к папке
        guard
            let data = image.pngData(),
            let url = getURLForImage(imageName: imageName, folderName: folderName)
        else { return }
        
        //Сохранения изображения в папке
        do {
            try data.write(to: url)
        } catch let error {
            print("Error saving image. ImageName: \(imageName). \(error)")
        }
    }
    
    ///Метод получения изображения из файлового менеджера
    func getImage(imageName: String, folderName: String) -> UIImage? {
        guard
            let url = getURLForImage(imageName: imageName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path) else {
                return nil
            }
        return UIImage(contentsOfFile: url.path)
    }
    
    ///Метод создания папки, если это необходимо
    private func createFolderIfNeeded(folderName: String) {
        ///Создание указателя на местонахождение в системе папки
        guard let url = getURLForFolder(folderName: folderName) else { return }
        //Если путь к данному файловому менеджеру не существует, то запускается следующий код
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("Error creating directory. FolderName: \(folderName). \(error)")
            }
        }
    }
    
    ///Метод получения адреса хранения полученных изображений валюты
    private func getURLForFolder(folderName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(folderName)
    }
    
    ///Метод получения адреса хранения конкретного изображенитя валюты
    private func getURLForImage(imageName: String, folderName: String) -> URL? {
        guard let folderURL = getURLForFolder(folderName: folderName) else {
            return nil
        }
        return folderURL.appendingPathComponent(imageName + ".png")
    }
}
