import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import os
import io
import sys
import seaborn as sns

def read_text_file(filepath):
    with open(filepath, 'r') as file:
        return file.read()


def get_line_starting_with(txt, starts_with):
    first_index = txt.find(starts_with)
    last_index = txt.find('\n', first_index)

    return txt[first_index: last_index]

def read_measures(filepath):
    result = pd.DataFrame()

    for subdir, dirs, files in os.walk(filepath):
        for file in files:
            filepath = subdir + os.sep + file

            txt = read_text_file(filepath)
            # java_version = get_line_starting_with(txt, 'java.vm.name:').replace('java.vm.name: ', '').split(' ', 1)[0] + \
            #                ' ' + get_line_starting_with(txt, 'java.vm.version:').replace('java.vm.version: ', '')

            # java_version = java_version.replace('Java 25.241-b07', 'Java 1.8.0')
            java_version = file.replace('benchmark_', '').replace('.scsv', '').replace('-','')

            data_string = io.StringIO("\n".join([line for line in txt.split('\n') if ';' in line]))

            df = pd.read_csv(data_string, sep=';', decimal=',')
            df['java_version'] = java_version
            # df['memory'] = get_line_starting_with(txt, '-Xmx').replace('-Xmx', '')
            df['memory'] = pd.to_numeric(get_line_starting_with(txt, '-Xmx').replace('-Xmx', ''))

            result = result.append(df)

    return result


def print_heatmaps(measures):
    for current_elements_size in measures['Param: ELEMENTS'].unique():
        plt.clf()
        current_df = measures[measures['Param: ELEMENTS'] == current_elements_size]

        Index = current_df['java_version'].unique()
        Cols = current_df['memory'].unique()
        df = pd.DataFrame(current_df['Score'].values.reshape(len(Index), len(Cols)), index=Index, columns=Cols)

        sns.heatmap(df, annot=True, fmt='.3g').set_title('Throughput of summing array elements (size: ' + str(current_elements_size) + ')')
        # plt.show()
        plt.xlabel("Memory [GB]")
        plt.ylabel("Java version")
        plt.savefig(str(current_elements_size) + '.png', bbox_inches="tight", dpi=150)


if __name__ == '__main__':
    input_dir = sys.argv[1:][0]
    output_file = sys.argv[1:][1]

    measures = read_measures(input_dir).sort_values(by='java_version')

    iterations_set = measures['Param: ELEMENTS'].unique()
    for current_iterations_param in iterations_set:
        fig = plt.figure()
        data_for_current_iterations_param = measures[measures['Param: ELEMENTS'] == current_iterations_param]

        test_names = np.unique(data_for_current_iterations_param['Benchmark'].to_numpy())

        # for test_name in test_names:
        for test_name in test_names[0:1]:
            data_subset = data_for_current_iterations_param[data_for_current_iterations_param['Benchmark'] == test_name]
            plt.errorbar(data_subset['java_version'], data_subset['Score'], data_subset['Score Error (99,9%)'],
                         label=test_name, lw=0.5, capsize=5, capthick=0.5, marker='o', markersize=2)

        plt.title("Sum of {:d} elements".format(current_iterations_param))
        plt.xlabel("Java version")
        plt.ylabel("Throughput [ops/s]")

        plt.xticks(rotation='vertical')
        plt.savefig(output_file, bbox_inches="tight", dpi=150)
