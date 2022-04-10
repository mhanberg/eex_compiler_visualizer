defmodule EexCompilerViewer.ViewersTest do
  use EexCompilerViewer.DataCase

  alias EexCompilerViewer.Viewers

  describe "viewers" do
    alias EexCompilerViewer.Viewers.Viewer

    import EexCompilerViewer.ViewersFixtures

    @invalid_attrs %{}

    test "list_viewers/0 returns all viewers" do
      viewer = viewer_fixture()
      assert Viewers.list_viewers() == [viewer]
    end

    test "get_viewer!/1 returns the viewer with given id" do
      viewer = viewer_fixture()
      assert Viewers.get_viewer!(viewer.id) == viewer
    end

    test "create_viewer/1 with valid data creates a viewer" do
      valid_attrs = %{}

      assert {:ok, %Viewer{} = viewer} = Viewers.create_viewer(valid_attrs)
    end

    test "create_viewer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Viewers.create_viewer(@invalid_attrs)
    end

    test "update_viewer/2 with valid data updates the viewer" do
      viewer = viewer_fixture()
      update_attrs = %{}

      assert {:ok, %Viewer{} = viewer} = Viewers.update_viewer(viewer, update_attrs)
    end

    test "update_viewer/2 with invalid data returns error changeset" do
      viewer = viewer_fixture()
      assert {:error, %Ecto.Changeset{}} = Viewers.update_viewer(viewer, @invalid_attrs)
      assert viewer == Viewers.get_viewer!(viewer.id)
    end

    test "delete_viewer/1 deletes the viewer" do
      viewer = viewer_fixture()
      assert {:ok, %Viewer{}} = Viewers.delete_viewer(viewer)
      assert_raise Ecto.NoResultsError, fn -> Viewers.get_viewer!(viewer.id) end
    end

    test "change_viewer/1 returns a viewer changeset" do
      viewer = viewer_fixture()
      assert %Ecto.Changeset{} = Viewers.change_viewer(viewer)
    end
  end
end
