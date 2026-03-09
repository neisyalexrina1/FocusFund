USE master;
GO

-- Drop Database if exists to reset
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'FocusFundDB')
BEGIN
    DROP DATABASE FocusFundDB;
END
GO