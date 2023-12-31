//
//  ContentView.swift
//  CloudKitExample
//
//  Created by Marcelo de Araújo on 18/11/23.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        icloudCRUDview
    }

    var tabBarView: some View {
        TabView {
            icloudCRUDview
            icloudStatusView
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }

    // MARK: - CRUD

    var icloudCRUDview: some View {
        NavigationStack {
            listView
                .safeAreaInset(edge: .bottom, content: inputViews)
                .padding()
                .toolbar(content: pushNotificationView)
                .onAppear(perform: viewModel.requestNotificationPermission)
                .navigationTitle("CloudKit")
                .toolbarBackground(.visible, for: .navigationBar)
                .navigationBarTitleDisplayMode(.large)
        }
    }

    private func inputViews() -> some View {
        VStack {
            textFieldView
            addButton
        }
    }

    private var textFieldView: some View {
        TextField("Enter text", text: $viewModel.textValue)
            .frame(height: 55)
            .padding(.leading)
            .background(Color.gray.opacity(0.2), in: RoundedRectangle(cornerRadius: 8))
            .background(RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 1))
            .overlay(alignment: .trailing, content: addImageView)
    }

    private var addButton: some View {
        Button {
            viewModel.addButtonClicked()
        } label: {
            Text("Add")
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
                .background(RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 1))
        }
    }

    private func addImageView() -> some View {
        Button {
            viewModel.addButtonClicked(true)
        } label: {
            Image(systemName: "paperclip")
                .padding(10)

                .background(.gray.opacity(0.3))
                .clipShape(Circle())
                .background(Circle().stroke(lineWidth: 1))
                .tint(.red)
        }
        .padding(.trailing, 5)
    }

    private var listView: some View {
        List {
            ForEach(viewModel.records, id: \.self) { record in
                HStack {
                    Text(record.name)

                    if let url = record.imageURL,
                       let data = try? Data(contentsOf: url),
                       let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 25.0))
                    }
                }
                .onTapGesture {
                    viewModel.updateItem(record)
                }
            }
            .onDelete(perform: viewModel.deleteItem)
        }
        .listStyle(.plain)
        .overlay(content: placholderView)
    }

    @ViewBuilder
    private func placholderView() -> some View {
        if viewModel.records.isEmpty {
            Text("No Records")
                .font(.title2)
                .foregroundStyle(Color.gray)
        }
    }

    private func pushNotificationView() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(viewModel.isEnabled ? "UnSubscribe": "Subscribe") {
                viewModel.handlePushNotifications()
            }
            .buttonStyle(.bordered)
            .padding(.trailing)
        }
    }

    // MARK: - Status

    @StateObject private var viewModel = CloudKitViewModel()

    var icloudStatusView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("isSignedIn: \(viewModel.isSignedIn.description.capitalized)")
            Text("Error: \(viewModel.error.capitalized)")

            Text("Status: \(viewModel.userStatus.description.capitalized)")
            Text("Name: \(viewModel.userName)")
        }
        .padding()
        .background(Color.gray)
        .clipShape(RoundedRectangle(cornerRadius: 25.0))
        .shadow(color: .yellow, radius: 10)
    }
}

#Preview {
    ContentView()
}
