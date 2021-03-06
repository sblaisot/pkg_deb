defmodule PkgDeb.Format.Generators.Sysvinit do
  @moduledoc """
  This module produces a sysvinit file from the config and a template.
  """
  alias PkgCore.TemplateFinder

  def build(data_dir, config) do
    # debug "Building Sysvinit File"

    systemd_script =
      ["init_scripts", "sysvinit.eex"]
      |> TemplateFinder.retrieve(:pkg_deb)
      |> EEx.eval_file(
        description: config.description,
        name: config.name,
        base_path: config.base_path,
        uid: config.owner[:user]
      )

    out_dir =
      [data_dir, "etc", "init.d"]
      |> Path.join()

    :ok = File.mkdir_p(out_dir)

    :ok =
      [out_dir, config.sanitized_name]
      |> Path.join()
      |> File.write(systemd_script)

    :ok =
      [out_dir, config.sanitized_name]
      |> Path.join()
      |> File.chmod(0o755)
  end
end
