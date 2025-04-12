//
//  MarkdownBlockDirective.swift
//  MarkdownView
//
//  Created by Yanan Li on 2025/2/22.
//

import SwiftUI
import Markdown

struct MarkdownBlockDirective: View {
    var blockDirective: BlockDirective
    private var args: [BlockDirectiveArgument] {
        blockDirective
            .argumentText
            .parseNameValueArguments()
            .map { BlockDirectiveArgument($0) }
    }
    private var provider: (any BlockDirectiveDisplayable)? {
        for (name, provider) in configuration.blockDirectiveRenderer.providers {
            if name.localizedLowercase == blockDirective.name.localizedLowercase {
                return provider
            }
        }
        return nil
    }
    
    @Environment(\.markdownRendererConfiguration) private var configuration
    
    var body: some View {
        let text = blockDirective
            .children
            .compactMap { $0.format() }
            .joined()
        if let provider {
            provider
                .makeView(arguments: args, text: text)
                .erasedToAnyView()
        } else {
            CmarkNodeVisitor(configuration: configuration)
                .descendInto(blockDirective)
        }
    }
}
