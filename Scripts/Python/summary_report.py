import json
import pandas as pd

def create_summary_report(input_json,output_html):

    # Load data from JSON file
    with open(input_json, encoding="utf8") as src:
        data = json.load(src)

    # Convert JSON data to Pandas DataFrame
    # if
    df = pd.DataFrame(data["vulnerabilities"])

    cell_hover = {
        'selector': 'td:hover',
        'props': [('background-color', '#00006678')]
    }
    index_names = {
        'selector': '.index_name',
        'props': 'font-style: italic; color: darkgrey; font-weight:normal;'
    }
    headers = {
        'selector': 'th:not(.index_name)',
        'props': 'background-color: #000066; color: white;'
    }

    # Style DataFrame
    styled_df = df.style.set_table_styles([cell_hover, index_names, headers])
    
    table = styled_df.to_html()
    print(table)
    # Write table to file
    with open(output_html, 'w', encoding="utf8") as dest:
        dest.write(table)

if __name__ == "__main__":
    input_json = "sample_files/snyk-example.json"
    output_html = "sample_files/snyk-example.html"
    create_summary_report(input_json,output_html)
