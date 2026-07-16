#!/usr/bin/env python3
"""
Code Generator Module for the Code Generator Agent

Generates code based on patterns and requirements for multiple languages.
"""

import os
import re
from typing import Dict, List


class CodeGenerator:
    """Generates code based on requirements and patterns."""

    def __init__(self, output_dir: str = "generated"):
        self.output_dir = output_dir
        os.makedirs(output_dir, exist_ok=True)

    def generate_swift_class(self, class_name: str, properties: List[str]) -> str:
        """Generate a Swift class template."""
        code = f"""import Foundation

class {class_name} {{
"""
        for prop in properties:
            code += f"    var {prop}\n"

        code += f"""    
    init({', '.join([f'{p}: String' for p in properties])}) {{
"""
        for prop in properties:
            code += f"        self.{prop} = {prop}\n"

        code += """    }
}
"""
        return code

    def generate_python_class(self, class_name: str, properties: List[str]) -> str:
        """Generate a Python class template."""
        code = f"""class {class_name}:
    \"\"\"Generated {class_name} class.\"\"\"\n
    def __init__(self, {', '.join(properties)}):
"""
        for prop in properties:
            code += f"        self.{prop} = {prop}\n"

        code += """    
    def __repr__(self):
        return f\"{self.__class__.__name__}(...)\"
"""
        return code

    def generate_javascript_class(self, class_name: str, properties: List[str]) -> str:
        """Generate a JavaScript class template."""
        code = f"""class {class_name} {{
    constructor({', '.join(properties)}) {{
"""
        for prop in properties:
            code += f"        this.{prop} = {prop};\n"

        code += """    }
    
    toString() {
        return `${this.constructor.name}(...)`;
    }
}

module.exports = {class_name};
"""
        return code

    def generate_api_endpoint_swift(self, endpoint_name: str, method: str = "GET") -> str:
        """Generate a Swift API endpoint template."""
        code = f"""import Foundation

class {endpoint_name}API {{
    private let session: URLSession
    
    init(session: URLSession = .shared) {{
        self.session = session
    }}
    
    func {method.lower()}(path: String) async throws -> Data {{
        guard let url = URL(string: path) else {{
            throw NSError(domain: "Invalid URL", code: -1)
        }}
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {{
            throw NSError(domain: "HTTP Error", code: -1)
        }}
        
        return data
    }}
}}
"""
        return code

    def generate_python_function(self, function_name: str, params: List[str]) -> str:
        """Generate a Python function template."""
        code = f"""def {function_name}({', '.join(params)}):
    \"\"\"Generated function.
    
    Args:
"""
        for param in params:
            code += f"        {param}: Parameter description\n"

        code += """    
    Returns:
        Generated result
    \"\"\"
    pass
"""
        return code

    def save_generated_file(self, filename: str, content: str) -> str:
        """Save generated code to file."""
        file_path = os.path.join(self.output_dir, filename)
        with open(file_path, 'w') as f:
            f.write(content)
        return file_path

    def generate_from_spec(self, spec: Dict) -> Dict[str, str]:
        """Generate code based on specification.
        
        Args:
            spec: Dictionary with language, type, name, and properties
            
        Returns:
            Dictionary with filename and generated code
        """
        generated = {}
        language = spec.get('language', 'python').lower()
        gen_type = spec.get('type', 'class')
        name = spec.get('name', 'Generated')
        properties = spec.get('properties', [])

        if language == 'swift':
            code = self.generate_swift_class(name, properties)
            filename = f"{name}.swift"
        elif language == 'python':
            code = self.generate_python_class(name, properties)
            filename = f"{name.lower()}.py"
        elif language == 'javascript':
            code = self.generate_javascript_class(name, properties)
            filename = f"{name}.js"
        else:
            return {"error": f"Unsupported language: {language}"}

        file_path = self.save_generated_file(filename, code)
        generated[filename] = code

        return generated


if __name__ == "__main__":
    generator = CodeGenerator()
    
    # Example usage
    spec = {
        'language': 'python',
        'type': 'class',
        'name': 'User',
        'properties': ['id', 'name', 'email']
    }
    
    result = generator.generate_from_spec(spec)
    for filename, code in result.items():
        print(f"Generated {filename}:")
        print(code)
