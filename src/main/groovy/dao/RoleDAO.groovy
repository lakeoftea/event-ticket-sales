package dao

import entity.Role

interface RoleDAO {
    Role addRole(String name, String description)
    boolean removeRoleById(int id)
    boolean removeRoleByName(String name)
    Role getRoleById(int id)
    Role getRoleByName(String name)
    Role updateRoleNameAndDescription(int id, String name, String description)
    List<Role> getAllRoles()
}