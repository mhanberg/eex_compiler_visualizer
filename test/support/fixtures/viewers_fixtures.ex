defmodule EexCompilerViewer.ViewersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `EexCompilerViewer.Viewers` context.
  """

  @doc """
  Generate a viewer.
  """
  def viewer_fixture(attrs \\ %{}) do
    {:ok, viewer} =
      attrs
      |> Enum.into(%{

      })
      |> EexCompilerViewer.Viewers.create_viewer()

    viewer
  end
end
